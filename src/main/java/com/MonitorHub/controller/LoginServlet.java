package com.MonitorHub.controller;

import com.MonitorHub.config.DatabaseConfig;
import com.MonitorHub.model.User;
import com.MonitorHub.util.PasswordUtil;

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
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    private static final String LOGIN_VIEW_PATH = "/WEB-INF/pages/login.jsp";


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("LoginServlet handling GET request - forwarding to login page.");

        try {
             HttpSession session = request.getSession(false);
             if (session != null) {
                 session.removeAttribute("loginError");
             }
            request.getRequestDispatcher(LOGIN_VIEW_PATH).forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error forwarding to login page: " + LOGIN_VIEW_PATH, e);
            if (!response.isCommitted()) {
                 response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display login page.");
            }
        }
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("LoginServlet handling POST request - attempting login.");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // --- Input Validation ---
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("loginError", "Email and password are required.");
            LOGGER.warning("Login attempt failed: Missing email or password.");
            request.getRequestDispatcher(LOGIN_VIEW_PATH).forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT u.userid, u.firstname, u.lastname, u.email, u.phone, u.password_hash, u.created_at, r.role_name " +
                     "FROM Users u " +
                     "LEFT JOIN UserRoles ur ON u.userid = ur.userid " +
                     "LEFT JOIN Roles r ON ur.roleid = r.roleid " +
                     "WHERE u.email = ?";

        try {
            conn = DatabaseConfig.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email.trim());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // --- User Found ---
                String storedHash = rs.getString("password_hash");

                if (PasswordUtil.checkPassword(password, storedHash)) {
                    // --- Password Matches - Login Successful ---
                    int userId = rs.getInt("userid");
                    String firstName = rs.getString("firstname");
                    String lastName = rs.getString("lastname");
                    String phone = rs.getString("phone");
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    String roleName = rs.getString("role_name");
                    String imageUrl = null; // Placeholder

                    User user = new User(userId, firstName, lastName, email.trim(), phone, createdAt, roleName, imageUrl);

                    HttpSession session = request.getSession(true);
                    session.setAttribute("user", user);

                    LOGGER.log(Level.INFO, "User {0} logged in successfully with role {1}", new Object[]{email.trim(), roleName});

                    // --- Role-based Redirection ---
                    String redirectURL;
                    if ("Admin".equalsIgnoreCase(roleName)) {
                         redirectURL = request.getContextPath() + "/admin/dashboard";
                         LOGGER.info("Redirecting Admin user to: " + redirectURL);
                    } else {
                         redirectURL = request.getContextPath() + "/home";
                         LOGGER.info("Redirecting Customer user to: " + redirectURL);
                    }
                    response.sendRedirect(redirectURL);
                    return;

                } else {
                    // --- Password Does Not Match ---
                    LOGGER.log(Level.WARNING, "Incorrect password attempt for user {0}", email.trim());
                    request.setAttribute("loginError", "Invalid email or password.");
                    request.getRequestDispatcher(LOGIN_VIEW_PATH).forward(request, response);
                    return;
                }
            } else {
                // --- User Not Found ---
                LOGGER.log(Level.WARNING, "Login attempt for non-existent email: {0}", email.trim());
                request.setAttribute("loginError", "Invalid email or password.");
                request.getRequestDispatcher(LOGIN_VIEW_PATH).forward(request, response);
                return;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during login for " + email.trim(), e);
            request.setAttribute("loginError", "An internal database error occurred. Please try again later.");
            request.getRequestDispatcher(LOGIN_VIEW_PATH).forward(request, response);
            return;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during login for " + email.trim(), e);
            request.setAttribute("loginError", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher(LOGIN_VIEW_PATH).forward(request, response);
            return; 
        } finally {
            DatabaseConfig.closeResources(conn, pstmt, rs);
            LOGGER.fine("Database resources closed for login attempt.");
        }
    }
}