package com.MonitorHub.controller;

import com.MonitorHub.config.DatabaseConfig;
import com.MonitorHub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminUserServlet.class.getName());
    private static final String USER_ADMIN_VIEW = "/WEB-INF/pages/userAdmin.jsp";
    private static final String LOGIN_PATH = "/login";
    private static final String ADMIN_USERS_PATH = "/admin/users";
    private static final String DASHBOARD_PATH = "/admin/dashboard";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("AdminUserServlet handling GET request for /admin/users.");
        HttpSession session = request.getSession(false);

        // --- Authorization Check ---
        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("No session or user found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + LOGIN_PATH + "?message=Session+Expired");
            return;
        }
        User loggedInUser = (User) session.getAttribute("user");
        if (!"Admin".equalsIgnoreCase(loggedInUser.getRoleName())) { // Assuming roleName is correctly set in session User obj
            LOGGER.warning("User '" + loggedInUser.getEmail() + "' is not Admin. Redirecting to dashboard.");
            response.sendRedirect(request.getContextPath() + DASHBOARD_PATH + "?error=Access+Denied+to+User+Management");
            return;
        }
        // --- End Authorization Check ---

        // --- Fetch Data Directly from DB ---
        try {
            List<User> userList = getAllUsersWithRolesFromDB(); // Updated method call
            request.setAttribute("userList", userList);
            request.setAttribute("pageTitle", "Manage Users");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error fetching users.", e);
            request.setAttribute("dbError", "Could not retrieve user data from the database. Please try again later.");
        }

        // --- Forward to JSP ---
        try {
            LOGGER.info("Forwarding request to user admin view: " + USER_ADMIN_VIEW);
            request.getRequestDispatcher(USER_ADMIN_VIEW).forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error forwarding to JSP " + USER_ADMIN_VIEW, e);
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display the user management page.");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("AdminUserServlet handling POST request for /admin/users.");
        HttpSession session = request.getSession(false);

        // --- Authorization Check ---
         if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + LOGIN_PATH + "?message=Session+Expired");
            return;
        }
        User loggedInUser = (User) session.getAttribute("user");
         if (!"Admin".equalsIgnoreCase(loggedInUser.getRoleName())) {
             response.sendRedirect(request.getContextPath() + DASHBOARD_PATH + "?error=Access+Denied");
            return;
        }
        // --- End Authorization Check ---

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + ADMIN_USERS_PATH;

        if ("delete".equals(action)) {
            handleDeleteAction(request, response, loggedInUser);
        } else {
            LOGGER.warning("Received POST request with unknown or missing action: " + action);
            response.sendRedirect(redirectUrl + "?error=" + java.net.URLEncoder.encode("Invalid action specified.", "UTF-8"));
        }
    }

    // --- Helper Method for Delete Action ---
    private void handleDeleteAction(HttpServletRequest request, HttpServletResponse response, User loggedInUser) throws IOException {
        String userIdStr = request.getParameter("userId");
        String redirectUrl = request.getContextPath() + ADMIN_USERS_PATH;
        int userIdToDelete = -1;
        boolean deleteSuccess = false;
        String messageKey = "error";
        String messageValue = "Invalid User ID provided for deletion.";

        try {
            userIdToDelete = Integer.parseInt(userIdStr);

            if (loggedInUser.getUserid() == userIdToDelete) {
                messageValue = "Admins cannot delete their own account.";
                LOGGER.warning("Admin user " + loggedInUser.getEmail() + " attempted to delete own account (ID: " + userIdToDelete + "). Action blocked.");
            } else {
                LOGGER.info("Attempting deletion for user ID: " + userIdToDelete);
                // Call the DB method directly
                deleteSuccess = deleteUserFromDB(userIdToDelete);

                if (deleteSuccess) {
                    messageKey = "success";
                    messageValue = "User (ID: " + userIdToDelete + ") deleted successfully.";
                    LOGGER.info(messageValue);
                } else {
                    messageValue = "User (ID: " + userIdToDelete + ") not found or could not be deleted (perhaps due to existing orders/relations).";
                    LOGGER.warning(messageValue);
                }
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid User ID format for deletion: " + userIdStr);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during user deletion (ID: " + userIdStr + ").", e);
            messageValue = "Database error occurred during deletion. Check constraints or logs.";
        }
        response.sendRedirect(redirectUrl + "?" + messageKey + "=" + java.net.URLEncoder.encode(messageValue, "UTF-8"));
    }


    // --- Internal Database Methods ---

    /**
     * Retrieves all users directly from the database, joining with Roles to get the role name.
     * Assumes a user has AT MOST ONE role for simplicity in this view, uses MAX() to pick one if multiple exist.
     * Adjust the MAX() logic if users can have multiple roles displayed differently.
     * Also fetches image URL from UserImages.
     * @return List of User objects
     * @throws SQLException if a database access error occurs
     */
    private List<User> getAllUsersWithRolesFromDB() throws SQLException {
        List<User> userList = new ArrayList<>();
        // Updated SQL to JOIN Users, UserRoles, and Roles.
        // Added LEFT JOIN for UserImages to get profile image URL.
        // Used MAX(r.role_name) and GROUP BY u.userid to handle potential multiple roles per user
        // (it will pick one, typically 'Admin' if both 'Admin' and 'Customer' exist due to alphabetical order).
        // Select image URL from UserImages where image_type is 'profile' (or adjust if needed).
        String sql = "SELECT u.userid, u.firstname, u.lastname, u.email, u.phone, u.created_at, " +
                     "MAX(r.role_name) AS role_name, " +
                     "MAX(img.image_url) AS image_url " +
                     "FROM Users u " +
                     "LEFT JOIN UserRoles ur ON u.userid = ur.userid " +
                     "LEFT JOIN Roles r ON ur.roleid = r.roleid " +
                     "LEFT JOIN UserImages ui ON u.userid = ui.userid AND ui.image_type = 'profile' " +
                     "LEFT JOIN Images img ON ui.imageid = img.imageid " + 
                     "GROUP BY u.userid, u.firstname, u.lastname, u.email, u.phone, u.created_at " +
                     "ORDER BY u.userid ASC";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (conn == null) {
                 LOGGER.severe("Failed to get database connection for fetching users.");
                 throw new SQLException("Database connection failed.");
            }

            LOGGER.fine("Executing query: " + sql);
            while (rs.next()) {
                User user = new User();
                user.setUserid(rs.getInt("userid"));
                user.setFirstname(rs.getString("firstname"));
                user.setLastname(rs.getString("lastname"));
                user.setEmail(rs.getString("email"));
                String phone = rs.getString("phone");
                user.setPhone(rs.wasNull() ? null : phone);
                user.setCreatedAt(rs.getTimestamp("created_at"));

                String roleName = rs.getString("role_name");
                user.setRoleName(roleName); // Can be null

                String imageUrl = rs.getString("image_url");
                user.setImageUrl(imageUrl); // Can be null

                userList.add(user);
            }
            LOGGER.info("Fetched " + userList.size() + " users with roles directly from database.");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all users with roles directly from database", e);
            throw e;
        }
        return userList;
    }

    /**
     * Deletes a user by ID directly from the database.
     * Note: ON DELETE CASCADE in UserRoles, UserImages should handle related entries.
     * ON DELETE RESTRICT in Sales will prevent deletion if sales exist.
     * @param userId The ID of the user to delete
     * @return true if deletion was successful, false otherwise
     * @throws SQLException if a database access error occurs
     */
    private boolean deleteUserFromDB(int userId) throws SQLException {
        // The DELETE statement correctly targets only the Users table.
        // Foreign key constraints (CASCADE/RESTRICT) handle related tables.
        String sql = "DELETE FROM Users WHERE userid = ?";
        boolean deleted = false;

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

             if (conn == null) {
                 LOGGER.severe("Failed to get database connection for deleting user.");
                 throw new SQLException("Database connection failed.");
             }

            pstmt.setInt(1, userId);
            LOGGER.info("Executing direct DB update (delete): userid=" + userId);
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                deleted = true;
                LOGGER.info("Successfully deleted user directly from database (ID: " + userId + ")");
            } else {
                LOGGER.warning("No user found with ID: " + userId + " to delete directly from database.");
            }

        } catch (SQLException e) {
            // Check for specific constraint violation errors if needed
            if (e.getSQLState().startsWith("23")) { 
                 LOGGER.log(Level.WARNING, "Could not delete user (ID: " + userId + ") due to existing related records (e.g., sales).", e);
                 return false;
            } else {
                LOGGER.log(Level.SEVERE, "Error deleting user directly from database (ID: " + userId + ")", e);
                throw e;
            }
        }
        return deleted;
    }
}