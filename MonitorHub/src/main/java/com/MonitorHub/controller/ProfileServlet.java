package com.MonitorHub.controller;


import com.MonitorHub.config.DatabaseConfig;
import com.MonitorHub.model.User;           

import java.io.IOException;
import java.sql.Connection;       
import java.sql.PreparedStatement;   
import java.sql.SQLException;       
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;



@WebServlet("/profile")
// NO @MultipartConfig needed
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());
    private static final String PROFILE_VIEW_PATH = "/WEB-INF/pages/profile.jsp";
    private static final String LOGIN_PATH = "/login"; // Relative to context root


    @Override
    public void init() {
       // No DAO initialization or directory creation needed
       LOGGER.info("ProfileServlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ProfileServlet handling GET request.");
        HttpSession session = request.getSession(false);

        // Check login status
        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("User not logged in. Redirecting to login page.");
            response.sendRedirect(request.getContextPath() + LOGIN_PATH + "?message=Please+login+to+view+your+profile.");
            return;
        }

        // Check for flash messages from POST redirect
        String successMessage = (String) session.getAttribute("profileSuccess");
        String errorMessage = (String) session.getAttribute("profileError");
        if (successMessage != null) {
            request.setAttribute("profileSuccess", successMessage);
            session.removeAttribute("profileSuccess"); 
        }
        if (errorMessage != null) {
            request.setAttribute("profileError", errorMessage);
            session.removeAttribute("profileError"); 
        }

        // Forward to the profile page
        LOGGER.info("User logged in. Forwarding to profile page: " + PROFILE_VIEW_PATH);
        try {
            request.getRequestDispatcher(PROFILE_VIEW_PATH).forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error forwarding to profile page: " + PROFILE_VIEW_PATH, e);
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display profile page.");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ProfileServlet handling POST request for profile update.");
        HttpSession session = request.getSession(false);

        // 1. Security Check: Ensure user is logged in
        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("Unauthorized POST attempt to /profile. Redirecting to login.");
            session = request.getSession();
            session.setAttribute("profileError", "Your session expired. Please login again to update your profile.");
            response.sendRedirect(request.getContextPath() + LOGIN_PATH);
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String successMessage = null;
        String errorMessage = null;
        boolean updateSuccessful = false;

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 2. Extract Form Data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone"); // Can be null or empty

            // --- Direct Database Update Logic ---
            String sql = "UPDATE users SET firstname = ?, lastname = ?, phone = ? WHERE userid = ?";

            conn = DatabaseConfig.getConnection(); // Get connection
            pstmt = conn.prepareStatement(sql);

            // Set parameters carefully, handling potential null phone
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            if (phone != null && !phone.trim().isEmpty()) {
                pstmt.setString(3, phone.trim());
            } else {

                pstmt.setNull(3, java.sql.Types.VARCHAR);
            }
            pstmt.setInt(4, currentUser.getUserid());

            // Execute update
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                updateSuccessful = true;
                LOGGER.log(Level.INFO, "User profile updated successfully in database for userid: {0}", currentUser.getUserid());

                // Create a *new* user object or update the existing one
                User updatedUser = new User();
                updatedUser.setUserid(currentUser.getUserid());
                updatedUser.setFirstname(firstName);
                updatedUser.setLastname(lastName);
                updatedUser.setPhone(phone != null ? phone.trim() : null); 
                updatedUser.setEmail(currentUser.getEmail()); 
                updatedUser.setCreatedAt(currentUser.getCreatedAt()); 
                updatedUser.setRoleName(currentUser.getRoleName());
                updatedUser.setImageUrl(currentUser.getImageUrl()); 

                session.setAttribute("user", updatedUser); 
                successMessage = "Profile updated successfully!";

            } else {

                errorMessage = "Failed to update profile. User not found or no changes made.";
                LOGGER.log(Level.WARNING, "User profile update failed for userid: {0}. No rows affected.", currentUser.getUserid());
                updateSuccessful = false;
            }
            // --- End Database Update Logic ---

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error updating profile for userid: " + currentUser.getUserid(), e);
            errorMessage = "A database error occurred. Please try again later.";
            updateSuccessful = false; // Ensure flag is false on SQL error
        } catch (Exception e) {
            // Catch other potential errors (though less likely here without file uploads)
            LOGGER.log(Level.SEVERE, "Unexpected error processing profile update for userid: " + currentUser.getUserid(), e);
            errorMessage = "An unexpected error occurred while updating your profile.";
            updateSuccessful = false;
        } finally {
            // 7. Clean up JDBC resources
            // Note: DatabaseConfig.closeResources handles null checks internally
            DatabaseConfig.closeResources(conn, pstmt); // Use the helper method
            LOGGER.finer("Database resources closed for profile update.");
        }

        // 8. Redirect back to profile page (PRG Pattern) using flash attributes in session
        if (successMessage != null) {
            session.setAttribute("profileSuccess", successMessage);
        }
        // Only set error message if a success message wasn't set
        if (errorMessage != null && successMessage == null) {
            session.setAttribute("profileError", errorMessage);
        }

        // Redirect to the GET handler of the profile page
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    // No helper methods like isAllowedImageType or deleteOldProfilePicture needed
}