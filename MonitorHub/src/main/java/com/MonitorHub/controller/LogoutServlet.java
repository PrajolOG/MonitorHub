package com.MonitorHub.controller;

import com.MonitorHub.model.User; // Import User model

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet implementation class LogoutServlet
 * Handles user logout requests by invalidating the session
 * and redirecting to the login page servlet.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    /**
     * Handles POST requests for logout. Delegates to handleLogout.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    /**
     * Handles GET requests for logout. Delegates to handleLogout.
     * Allows logout via simple link click if needed.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    /**
     * Invalidates the user's session and redirects to the login servlet path.
     *
     * @param request  The HTTP request.
     * @param response The HTTP response.
     * @throws IOException If an input or output error occurs during redirect.
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        LOGGER.info("Logout request received.");
        HttpSession session = request.getSession(false); // Get existing session, don't create new one

        if (session != null) {
            String userEmail = "Unknown User";
            // Attempt to log which user is logging out
            Object userObj = session.getAttribute("user");
            if (userObj instanceof User) { // Use the imported User class
                userEmail = ((User) userObj).getEmail();
            }

            try {
                session.invalidate(); // Invalidate the session
                LOGGER.log(Level.INFO, "Session invalidated for user: {0}", userEmail);
            } catch (IllegalStateException e) {
                // Session might already be invalid, log it but continue redirect
                LOGGER.log(Level.WARNING, "Attempted to invalidate an already invalid session for user: {0}", userEmail);
            }
        } else {
             LOGGER.info("Logout called but no active session found.");
        }

        // *** IMPORTANT: Redirect to the Login SERVLET path, not the JSP ***
        String loginServletPath = request.getContextPath() + "/login";
        // Add a parameter to optionally show a "logged out" message on the login page
        String redirectURL = loginServletPath + "?loggedout=true";

        LOGGER.log(Level.INFO, "Redirecting to login page: {0}", redirectURL);
        try {
            response.sendRedirect(redirectURL);
        } catch (IOException | IllegalStateException e) {
             LOGGER.log(Level.SEVERE, "Error performing redirect after logout", e);
             // If redirect fails, maybe try sending a simple confirmation
             if (!response.isCommitted()) {
                 response.setContentType("text/plain");
                 response.getWriter().write("Logout successful, but redirect failed. Please navigate to the login page.");
             }
        }
    }
}