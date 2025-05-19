package com.MonitorHub.controller; // Make sure this package is correct

import com.MonitorHub.dao.OrderDAO;
import com.MonitorHub.model.Order;
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
import java.time.ZoneId;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/sales")
public class AdminSalesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminSalesServlet.class.getName());
    private static final String VIEW_PATH = "/WEB-INF/pages/adminSales.jsp";
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        LOGGER.info("AdminSalesServlet initialized with OrderDAO.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("AdminSalesServlet doGet called.");

        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        // Basic role check
        if (loggedInUser == null || !"Admin".equalsIgnoreCase(loggedInUser.getRoleName())) {
            LOGGER.warning("Unauthorized access attempt to /admin/sales by user: " + (loggedInUser != null ? loggedInUser.getEmail() : "null"));
            response.sendRedirect(request.getContextPath() + "/login?message=Unauthorized+access.");
            return;
        }

        List<Order> salesData = Collections.emptyList();
        BigDecimal totalRevenue = BigDecimal.ZERO;
        int numberOfSales = 0;

        try {
            salesData = orderDAO.getAllOrders();
            numberOfSales = salesData.size();

            for (Order order : salesData) {
                if (order.getTotalPrice() != null) {
                    totalRevenue = totalRevenue.add(order.getTotalPrice());
                }
                if (order.getOrderDate() != null) {
                    order.setOrderDateForJsp(
                        java.util.Date.from(order.getOrderDate().atZone(ZoneId.systemDefault()).toInstant())
                    );
                }
            }
            LOGGER.log(Level.INFO, "Sales summary: Total Revenue=${0}, Number of Sales={1}",
                    new Object[]{totalRevenue, numberOfSales});

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error fetching sales data for admin panel.", e);
            request.setAttribute("dbError", "Could not retrieve sales records due to a database issue. Please check server logs.");
        } catch (Exception e) { // Catch any other unexpected errors
            LOGGER.log(Level.SEVERE, "Unexpected error processing admin sales data.", e);
            request.setAttribute("dbError", "An unexpected error occurred. Please check server logs.");
        }


        Map<String, Object> summaryMetrics = new HashMap<>();
        summaryMetrics.put("totalRevenue", totalRevenue);
        summaryMetrics.put("numberOfSales", numberOfSales);

        request.setAttribute("salesData", salesData);
        request.setAttribute("summaryMetrics", summaryMetrics);

        try {
            request.getRequestDispatcher(VIEW_PATH).forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error forwarding request to " + VIEW_PATH, e);
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display the sales records page.");
            }
        }
    }
}