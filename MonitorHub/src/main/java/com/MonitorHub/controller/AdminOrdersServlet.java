package com.MonitorHub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest; // Import correct request type
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.MonitorHub.model.User; // For session check

@WebServlet("/admin/orders") // Map to the desired URL
public class AdminOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminOrdersServlet.class.getName());

    // Path to the JSP file that will display the orders
    private static final String ADMIN_ORDERS_VIEW = "/WEB-INF/pages/adminOrders.jsp";
    private static final String LOGIN_PATH = "/login"; // Your login servlet path
    private static final String DASHBOARD_PATH = "/admin/dashboard"; // Your admin dashboard path

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("AdminOrdersServlet handling GET request for /admin/orders (Static Mode).");
        HttpSession session = request.getSession(false);

        // --- Authorization Check ---
        // Pass the request object to the helper method
        if (!isAdminAuthorized(request, session, response)) return; // Pass request here
        // --- End Authorization Check ---

        // --- No data fetching needed for static placeholder ---

        // --- Forward to JSP ---
        try {
            LOGGER.info("Static Mode: Forwarding request to admin orders view: " + ADMIN_ORDERS_VIEW);
            request.setAttribute("pageTitle", "Manage Orders (Static)"); // Optional title
            request.getRequestDispatcher(ADMIN_ORDERS_VIEW).forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Static Mode: Error forwarding to JSP " + ADMIN_ORDERS_VIEW, e);
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + DASHBOARD_PATH + "?error=Could+not+display+orders+page.");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("AdminOrdersServlet handling POST request for /admin/orders (Static Mode) - Redirecting to GET.");
        HttpSession session = request.getSession(false);

        // --- Authorization Check ---
        // Pass the request object to the helper method
        if (!isAdminAuthorized(request, session, response)) return; // Pass request here
        // --- End Authorization Check ---

        // Placeholder POST handling (e.g., for Approve/Cancel actions later)
        String action = request.getParameter("action");
        String orderId = request.getParameter("orderId");
        LOGGER.warning("Received POST action '" + action + "' for order '" + orderId + "' - Not implemented.");
        response.sendRedirect(request.getContextPath() + "/admin/orders" + "?message=Action+" + action + "+not+implemented+yet.");
    }

    // --- Helper: Authorization Check (Corrected Signature) ---
    private boolean isAdminAuthorized(HttpServletRequest request, HttpSession session, HttpServletResponse response) throws IOException {
    // ^^^ Added HttpServletRequest request parameter

         if (session == null || session.getAttribute("user") == null) {
             LOGGER.warning("No session or user found for admin action.");
             // Use the request object to get context path
             response.sendRedirect(response.encodeRedirectURL(request.getContextPath() + LOGIN_PATH + "?message=Session+Expired"));
             return false;
         }
         User loggedInUser = (User) session.getAttribute("user");
         if (loggedInUser == null || !"Admin".equalsIgnoreCase(loggedInUser.getRoleName())) {
             LOGGER.warning("User " + (loggedInUser != null ? loggedInUser.getEmail() : "null") + " is not Admin. Denying access to orders.");
             // Use the request object to get context path
             response.sendRedirect(response.encodeRedirectURL(request.getContextPath() + DASHBOARD_PATH + "?error=Access+Denied"));
             return false;
         }
         return true;
     }
}