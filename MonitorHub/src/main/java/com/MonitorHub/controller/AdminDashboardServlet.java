package com.MonitorHub.controller; // Or your admin controller package

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.MonitorHub.model.User; // Import User model

// Map this servlet to handle requests for the admin dashboard
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    private static final String ADMIN_DASHBOARD_VIEW_PATH = "/WEB-INF/pages/admindashboard.jsp";
    private static final String LOGIN_PATH = "/login"; // Servlet path for login

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("AdminDashboardServlet handling GET request.");
        HttpSession session = request.getSession(false);

        // --- Authorization Check ---
        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("No session or user found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + LOGIN_PATH + "?message=Please%20login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"Admin".equalsIgnoreCase(user.getRoleName())) {
            LOGGER.warning("User " + user.getEmail() + " is not Admin. Redirecting to home.");
            // Redirect non-admins away (e.g., to home page servlet)
            response.sendRedirect(request.getContextPath() + "/home" + "?error=Access%20Denied");
            return;
        }
        // --- End Authorization Check ---


        // Optional: Load data needed for the admin dashboard
        // Example: fetch totals, recent orders, etc. from DAOs
        // request.setAttribute("totalSalesValue", salesService.getTotalSales());
        // request.setAttribute("recentOrders", orderService.getRecentOrders(5));
         LOGGER.info("Loading data for admin dashboard (placeholder)...");


        // Forward to the admin dashboard JSP inside WEB-INF
        try {
            LOGGER.log(Level.INFO, "Forwarding request to admin dashboard JSP: {0}", ADMIN_DASHBOARD_VIEW_PATH);
            request.getRequestDispatcher(ADMIN_DASHBOARD_VIEW_PATH).forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error forwarding to admin dashboard JSP: " + ADMIN_DASHBOARD_VIEW_PATH, e);
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display admin dashboard.");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Admin dashboard typically doesn't handle POST directly, redirect to GET
        doGet(request, response);
    }
}