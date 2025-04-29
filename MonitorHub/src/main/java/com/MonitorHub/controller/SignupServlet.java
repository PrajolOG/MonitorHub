package com.MonitorHub.controller;

import com.MonitorHub.config.DatabaseConfig;
import com.MonitorHub.model.User;
// import com.MonitorHub.util.EmailUtil; // No longer needed for verification
import com.MonitorHub.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement; // Needed for saveUser
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/signup-request", "/signup"})
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(SignupServlet.class.getName());
    private static final String SIGNUP_VIEW_PATH = "/WEB-INF/pages/signup.jsp";
    private static final String DEFAULT_ROLE = "Customer";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestedPath = request.getServletPath();
        if ("/signup".equals(requestedPath)) {
            LOGGER.info("SignupServlet handling GET for /signup - forwarding to signup page.");
            try {
                request.getRequestDispatcher(SIGNUP_VIEW_PATH).forward(request, response);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error forwarding to signup page: " + SIGNUP_VIEW_PATH, e);
                if (!response.isCommitted()) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display signup page.");
                }
            }
        } else {
             LOGGER.warning("GET request received for /signup-request - Method Not Allowed.");
             response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported for this URL.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestedPath = request.getServletPath();
        if (!"/signup-request".equals(requestedPath)) {
             LOGGER.warning("POST request received for unexpected path: " + requestedPath);
             response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request path for POST.");
             return;
        }

        LOGGER.info("SignupServlet handling POST for /signup-request - processing direct signup.");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // --- Get Form Data ---
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // --- Basic Server-Side Validation ---
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty()) {

            LOGGER.warning("Signup POST failed: Missing required fields.");
            out.print("{\"success\": false, \"message\": \"Missing required fields.\"}");
            out.flush();
            return;
        }

        // Trim inputs
        firstName = firstName.trim();
        lastName = lastName.trim();
        email = email.trim();
        phone = (phone != null) ? phone.trim() : null;

        if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            LOGGER.warning("Signup POST failed: Invalid email format for " + email);
            out.print("{\"success\": false, \"message\": \"Invalid email format.\"}");
            out.flush();
            return;
        }

        if (emailExists(email)) {
            LOGGER.log(Level.WARNING, "Signup POST failed: Attempt with existing email: {0}", email);
            out.print("{\"success\": false, \"message\": \"Email address is already registered.\"}");
            out.flush();
            return;
        }

        // --- Process Signup Directly ---
        Integer savedUserId = null;
        try {
            String hashedPassword = PasswordUtil.hashPassword(password);
            if (hashedPassword == null) {
                 LOGGER.severe("Password hashing returned null for email: " + email);
                 throw new ServletException("Password processing failed.");
            }

            // Create User object to save (without ID initially)
            User userToSave = new User();
            userToSave.setFirstname(firstName);
            userToSave.setLastname(lastName);
            userToSave.setEmail(email);
            userToSave.setPhone(phone);
            userToSave.setPasswordHash(hashedPassword);
            // Role will be assigned within saveUser

            LOGGER.info("Attempting to save user directly to database...");
            savedUserId = saveUser(userToSave);

            if (savedUserId != null) {
                // --- User Saved Successfully ---
                LOGGER.log(Level.INFO, "User {0} saved to database successfully (UserID: {1}).", new Object[]{email, savedUserId});
                LOGGER.info("Attempting to auto-login user...");

                // Create the User object for the session (NO password hash)
                User loggedInUser = new User(
                    savedUserId, firstName, lastName, email, phone, null, 
                    DEFAULT_ROLE, 
                    null 
                );

                // Store the user object in the session for auto-login
                HttpSession session = request.getSession(true);
                session.setAttribute("user", loggedInUser);
                LOGGER.log(Level.INFO, "User object placed in session for auto-login. Session ID: {0}", session.getId());

                // --- Determine Redirect URL ---
                String redirectURL;
                 if ("Admin".equalsIgnoreCase(loggedInUser.getRoleName())) {
                      redirectURL = request.getContextPath() + "/admin/dashboard";
                      LOGGER.info("Redirecting Admin user (unlikely on signup) to Admin Dashboard.");
                 } else {
                      redirectURL = request.getContextPath() + "/home";
                      LOGGER.info("Redirecting Customer user to Home Servlet.");
                 }

                // --- Respond with Success and Redirect URL ---
                out.print("{\"success\": true, \"redirectUrl\": \"" + redirectURL + "\"}");

            } else {
                // --- Save User Failed ---
                LOGGER.log(Level.SEVERE, "Failed to save user {0} to database (saveUser returned null).", email);
                out.print("{\"success\": false, \"message\": \"Failed to create your account due to a server error. Please try again later.\"}");
            }

        } catch (Exception e) { // Catch broad exceptions during hashing or saving attempt
            LOGGER.log(Level.SEVERE, "Error during direct signup process for " + email, e);
             if (!response.isCommitted()) {
                 out.print("{\"success\": false, \"message\": \"An internal server error occurred during signup. Please try again.\"}");
             }
        } finally {
            if (out != null) {
                out.flush();
            }
        }
    } 

    
    // It should handle inserting user, getting ID, getting role ID, inserting into UserRoles
    private Integer saveUser(User user) {
        LOGGER.log(Level.INFO, "[saveUser] Starting for email: {0}", user.getEmail());
        Connection conn = null;
        PreparedStatement pstmtUser = null;
        PreparedStatement pstmtRole = null;
        PreparedStatement pstmtUserRole = null;
        ResultSet generatedKeys = null;
        Integer userId = null;

        String sqlInsertUser = "INSERT INTO Users (firstname, lastname, email, phone, password_hash) VALUES (?, ?, ?, ?, ?)";
        String sqlGetRoleId = "SELECT roleid FROM Roles WHERE role_name = ?";
        String sqlInsertUserRole = "INSERT INTO UserRoles (userid, roleid) VALUES (?, ?)";

        try {
            LOGGER.info("[saveUser] Getting database connection...");
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false); // Start transaction
            LOGGER.info("[saveUser] Transaction started.");

            // 1. Insert User
            pstmtUser = conn.prepareStatement(sqlInsertUser, Statement.RETURN_GENERATED_KEYS);
            pstmtUser.setString(1, user.getFirstname());
            pstmtUser.setString(2, user.getLastname());
            pstmtUser.setString(3, user.getEmail());
            pstmtUser.setString(4, user.getPhone());
            pstmtUser.setString(5, user.getPasswordHash());
            int affectedRows = pstmtUser.executeUpdate();
            LOGGER.log(Level.INFO, "[saveUser] User INSERT affected rows: {0}", affectedRows);
            if (affectedRows == 0) throw new SQLException("Creating user failed, no rows affected.");

            // 2. Get User ID
            generatedKeys = pstmtUser.getGeneratedKeys();
            if (generatedKeys.next()) {
                userId = generatedKeys.getInt(1);
                LOGGER.log(Level.INFO, "[saveUser] Generated User ID: {0}", userId);
            } else {
                throw new SQLException("Creating user failed, no ID obtained.");
            }

            // 3. Get Role ID
            pstmtRole = conn.prepareStatement(sqlGetRoleId);
            pstmtRole.setString(1, DEFAULT_ROLE);
            ResultSet rsRole = pstmtRole.executeQuery();
            int roleId = -1;
            if (rsRole.next()) {
                roleId = rsRole.getInt("roleid");
                LOGGER.log(Level.INFO, "[saveUser] Found Role ID: {0} for Role: {1}", new Object[]{roleId, DEFAULT_ROLE});
            } else {
                LOGGER.log(Level.SEVERE, "[saveUser] Default role '{0}' not found!", DEFAULT_ROLE);
                throw new SQLException("Default role not found.");
            }
             DatabaseConfig.closeResources(null, pstmtRole, rsRole); // Close role resources early

            // 4. Insert into UserRoles
            pstmtUserRole = conn.prepareStatement(sqlInsertUserRole);
            pstmtUserRole.setInt(1, userId);
            pstmtUserRole.setInt(2, roleId);
            pstmtUserRole.executeUpdate();
            LOGGER.info("[saveUser] UserRoles INSERT executed.");

            // Commit
            conn.commit();
            LOGGER.log(Level.INFO, "[saveUser] Transaction committed successfully for user {0}", user.getEmail());

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[saveUser] SQLException for " + user.getEmail() + ": " + e.getMessage(), e);
            userId = null; // Ensure userId is null on error
            if (conn != null) try { conn.rollback(); LOGGER.warning("[saveUser] Transaction rolled back."); } catch (SQLException ex) { LOGGER.log(Level.SEVERE, "[saveUser] Error rolling back", ex); }
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "[saveUser] Unexpected Exception for " + user.getEmail(), e);
             userId = null;
              if (conn != null) try { conn.rollback(); } catch (SQLException ex) { /* ignored */ }
        } finally {
            LOGGER.info("[saveUser] Closing resources...");
            DatabaseConfig.closeResources(null, pstmtUser, generatedKeys); // Close user statement/keys
            DatabaseConfig.closeResources(null, pstmtUserRole, null);     // Close user-role statement
            DatabaseConfig.closeResources(conn, null, null);              // Close connection
            LOGGER.log(Level.INFO, "[saveUser] Finished for {0}. Returning UserID: {1}", new Object[]{user.getEmail(), userId});
        }
        return userId;
    }

    // emailExists method remains the same
    private boolean emailExists(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        String sql = "SELECT 1 FROM Users WHERE email = ? LIMIT 1";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;
        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email.trim());
            rs = pstmt.executeQuery();
            exists = rs.next();
            LOGGER.log(Level.FINE, "Email exists check for {0}: {1}", new Object[]{email, exists});
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if email exists: " + email, e);
            exists = false; // Fail safely (allow signup, let DB constraint catch it)
        } finally {
            DatabaseConfig.closeResources(conn, pstmt, rs);
        }
        return exists;
    }
}