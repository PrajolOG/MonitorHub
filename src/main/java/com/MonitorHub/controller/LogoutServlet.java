package com.MonitorHub.controller;

import com.MonitorHub.model.User;

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
 * Servlet implementation class LogoutServlet.
 * Handles user logout requests by invalidating the session
 * and redirecting to the login page servlet.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    /**
     * Handles POST requests for logout.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    /**
     * Handles GET requests for logout, allowing logout via a simple link.
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
        HttpSession session = request.getSession(false); 

        if (session != null) {
            String userEmail = "Unknown User";
            Object userObj = session.getAttribute("user");
            if (userObj instanceof User) {
                userEmail = ((User) userObj).getEmail();
            }

            try {
                session.invalidate();
                LOGGER.log(Level.INFO, "Session invalidated for user: {0}", userEmail);
            } catch (IllegalStateException e) {
                LOGGER.log(Level.WARNING, "Attempted to invalidate an already invalid session for user: {0}", userEmail);
            }
        } else {
             LOGGER.info("Logout called but no active session found.");
        }

        // Redirect to the Login SERVLET path, not the JSP directly.
        String loginServletPath = request.getContextPath() + "/login";
        // Add a parameter to indicate successful logout on the login page.
        String redirectURL = loginServletPath + "?loggedout=true";

        LOGGER.log(Level.INFO, "Redirecting to login page: {0}", redirectURL);
        try {
            response.sendRedirect(redirectURL);
        } catch (IOException | IllegalStateException e) {
             LOGGER.log(Level.SEVERE, "Error performing redirect after logout", e);
             if (!response.isCommitted()) {
                 response.setContentType("text/plain");
                 response.getWriter().write("Logout successful, but redirect failed. Please navigate to the login page.");
             }
        }
    }
}