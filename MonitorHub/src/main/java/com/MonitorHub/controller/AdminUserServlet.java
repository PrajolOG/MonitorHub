package com.MonitorHub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.MonitorHub.model.User; // Still useful for session check

// Map this servlet to the /admin/users path
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminUserServlet.class.getName());
    // The location of the JSP view file
    private static final String USER_ADMIN_VIEW = "/WEB-INF/pages/userAdmin.jsp";
    private static final String LOGIN_PATH = "/login"; // Your login servlet path
    private static final String DASHBOARD_PATH = "/admin/dashboard"; // Your admin dashboard path

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("AdminUserServlet handling GET request for /admin/users (Static Mode).");
        HttpSession session = request.getSession(false);

        // --- Authorization Check ---
        // Keep this check to ensure only logged-in admins can access
        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("Static Mode: No session or user found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + LOGIN_PATH + "?message=Session+Expired");
            return;
        }
        User loggedInUser = (User) session.getAttribute("user");
        // Check roleName if available in your User object from the session
        if (loggedInUser == null || !"Admin".equalsIgnoreCase(loggedInUser.getRoleName())) {
            LOGGER.warning("Static Mode: User is not Admin. Redirecting to dashboard.");
            response.sendRedirect(request.getContextPath() + DASHBOARD_PATH + "?error=Access+Denied");
            return;
        }
        // --- End Authorization Check ---

        // --- NO DATABASE INTERACTION ---
        // We are just forwarding to the static JSP

        // --- Forward to JSP ---
        try {
            LOGGER.info("Static Mode: Forwarding request to user admin view: " + USER_ADMIN_VIEW);
            request.setAttribute("pageTitle", "Manage Users (Static)"); // Example of passing simple data
            request.getRequestDispatcher(USER_ADMIN_VIEW).forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Static Mode: Error forwarding to JSP " + USER_ADMIN_VIEW, e);
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + DASHBOARD_PATH + "?error=Could+not+display+users+page.");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For now, POST requests (like delete attempts) will just redirect back to the GET handler
        // In a real app, this would handle the delete action.
        LOGGER.info("AdminUserServlet handling POST request for /admin/users (Static Mode) - Redirecting to GET.");
        response.sendRedirect(request.getContextPath() + "/admin/users" + "?message=Action+not+implemented+yet");
    }
}