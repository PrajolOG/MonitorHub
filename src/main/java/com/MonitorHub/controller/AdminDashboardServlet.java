package com.MonitorHub.controller;

import com.MonitorHub.dao.MonitorDAO;
import com.MonitorHub.dao.OrderDAO;
import com.MonitorHub.dao.UserDAO;
import com.MonitorHub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    private static final String ADMIN_DASHBOARD_VIEW_PATH = "/WEB-INF/pages/admindashboard.jsp";
    private static final String LOGIN_PATH = "/login";

    private UserDAO userDAO;
    private MonitorDAO monitorDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        monitorDAO = new MonitorDAO();
        orderDAO = new OrderDAO();
        LOGGER.info("AdminDashboardServlet initialized with all DAOs.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("AdminDashboardServlet handling GET request.");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("No session or user found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + LOGIN_PATH + "?message=Please%20login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"Admin".equalsIgnoreCase(user.getRoleName())) {
            LOGGER.warning("User " + user.getEmail() + " is not Admin. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/home" + "?error=Access%20Denied");
            return;
        }

        try {
            // 1. Total Sales Value
            BigDecimal totalSalesValue = orderDAO.getTotalSalesValue();
            request.setAttribute("totalSalesValue", totalSalesValue != null ? totalSalesValue : BigDecimal.ZERO);

            // 2. Total Users
            int totalUsersCount = userDAO.getTotalUserCount();
            request.setAttribute("totalUsersCount", totalUsersCount);

            // 3. Total Stock Items
            int totalStockQuantity = monitorDAO.getTotalStockQuantity();
            request.setAttribute("totalStockQuantity", totalStockQuantity);

            // OrderDAO.getRecentSalesForDashboard already prepares a List<Map<String, Object>>
            List<Map<String, Object>> recentSalesForJsp = orderDAO.getRecentSalesForDashboard(6);
            request.setAttribute("recentOrders", recentSalesForJsp != null ? recentSalesForJsp : Collections.emptyList());

            // MonitorDAO.getBestSellingMonitorsWithDetails now returns List<Map<String, Object>>
            List<Map<String, Object>> bestSellingData = monitorDAO.getBestSellingMonitorsWithDetails(5);
            request.setAttribute("topSellingMonitors", bestSellingData != null ? bestSellingData : Collections.emptyList());

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error loading dashboard data.", e);
            request.setAttribute("dashboardError", "Could not load dashboard data due to a database issue.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error loading dashboard data.", e);
            request.setAttribute("dashboardError", "An unexpected error occurred while loading data.");
        }

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
        doGet(request, response);
    }
}