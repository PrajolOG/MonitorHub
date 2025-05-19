package com.MonitorHub.controller;

import com.MonitorHub.dao.UserDAO;
import com.MonitorHub.model.User;

import java.io.IOException;
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
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());
    private static final String PROFILE_VIEW_PATH = "/WEB-INF/pages/profile.jsp";
    private static final String LOGIN_PATH = "/login";

    private UserDAO userDAO; // DAO instance

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO(); // Initialize DAO
        LOGGER.info("ProfileServlet initialized with UserDAO.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ProfileServlet handling GET request.");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("User not logged in. Redirecting to login page.");
            response.sendRedirect(request.getContextPath() + LOGIN_PATH + "?message=Please+login+to+view+your+profile.");
            return;
        }

        // Retrieve and clear flash messages from session
        String successMessage = (String) session.getAttribute("profileSuccess");
        String errorMessage = (String) session.getAttribute("profileError");
        String formFirstName = (String) session.getAttribute("form_firstName");
        String formLastName = (String) session.getAttribute("form_lastName");
        String formPhone = (String) session.getAttribute("form_phone");


        if (successMessage != null) {
            request.setAttribute("profileSuccess", successMessage);
            session.removeAttribute("profileSuccess");
        }
        if (errorMessage != null) {
            request.setAttribute("profileError", errorMessage);
            session.removeAttribute("profileError");

            // Repopulate form fields on error
            if (formFirstName != null) {
                request.setAttribute("form_firstName", formFirstName);
                session.removeAttribute("form_firstName");
            }
            if (formLastName != null) {
                request.setAttribute("form_lastName", formLastName);
                session.removeAttribute("form_lastName");
            }
            if (formPhone != null) {
                request.setAttribute("form_phone", formPhone);
                session.removeAttribute("form_phone");
            }
        }


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

        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("Unauthorized POST attempt to /profile. Redirecting to login.");
            session = request.getSession(); // Create one if null to store error
            session.setAttribute("profileError", "Your session expired. Please login again to update your profile.");
            response.sendRedirect(request.getContextPath() + LOGIN_PATH);
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String successMessage = null;
        String errorMessage = null;

        // 1. Extract and Trim Form Data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone"); // Optional

        // Trim inputs
        if (firstName != null) firstName = firstName.trim();
        if (lastName != null) lastName = lastName.trim();
        if (phone != null) phone = phone.trim();


        // 2. Server-Side Validation
        if (firstName == null || firstName.isEmpty()) {
            errorMessage = "First name cannot be empty.";
        } else if (lastName == null || lastName.isEmpty()) {
            errorMessage = "Last name cannot be empty.";
        } else if (firstName.length() > 50) { // Example length validation
            errorMessage = "First name cannot exceed 50 characters.";
        } else if (lastName.length() > 50) { // Example length validation
            errorMessage = "Last name cannot exceed 50 characters.";
        } else if (phone != null && !phone.isEmpty() && !phone.matches("^\\+?[0-9. ()-]{7,25}$")) { // Basic phone validation
            errorMessage = "Invalid phone number format.";
        }

        if (errorMessage != null) {
            LOGGER.warning("Profile update validation failed: " + errorMessage);
            session.setAttribute("profileError", errorMessage);
            session.setAttribute("form_firstName", firstName);
            session.setAttribute("form_lastName", lastName);
            session.setAttribute("form_phone", phone);
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // 3. Attempt to update profile using UserDAO
        try {
            boolean updateSuccessful = userDAO.updateUserProfile(currentUser.getUserid(), firstName, lastName, (phone != null && !phone.isEmpty() ? phone : null));

            if (updateSuccessful) {
                LOGGER.log(Level.INFO, "User profile updated successfully via DAO for userid: {0}", currentUser.getUserid());

                // Update the User object in the session
                User updatedUser = new User();
                updatedUser.setUserid(currentUser.getUserid());
                updatedUser.setFirstname(firstName);
                updatedUser.setLastname(lastName);
                updatedUser.setPhone( (phone != null && !phone.isEmpty() ? phone : null) );
                updatedUser.setEmail(currentUser.getEmail()); // Keep existing email
                updatedUser.setCreatedAt(currentUser.getCreatedAt()); // Keep existing creation date
                updatedUser.setRoleName(currentUser.getRoleName()); // Keep existing role
                updatedUser.setImageUrl(currentUser.getImageUrl()); // Keep existing image URL

                session.setAttribute("user", updatedUser);
                successMessage = "Profile updated successfully!";
            } else {
                errorMessage = "Failed to update profile. No changes were made or an issue occurred.";
                LOGGER.log(Level.WARNING, "User profile update via DAO failed for userid: {0}. DAO returned false.", currentUser.getUserid());
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error updating profile via DAO for userid: " + currentUser.getUserid(), e);
            errorMessage = "A database error occurred while updating your profile. Please try again later.";
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error processing profile update via DAO for userid: " + currentUser.getUserid(), e);
            errorMessage = "An unexpected error occurred. Please try again.";
        }

        // 4. Set flash messages and redirect
        if (successMessage != null) {
            session.setAttribute("profileSuccess", successMessage);
        }
        if (errorMessage != null && successMessage == null) { // Only set error if no success
            session.setAttribute("profileError", errorMessage);
            session.setAttribute("form_firstName", firstName);
            session.setAttribute("form_lastName", lastName);
            session.setAttribute("form_phone", phone);
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }
}