package com.MonitorHub.controller;

import com.MonitorHub.config.DatabaseConfig;
import com.MonitorHub.dao.MonitorDAO;
import com.MonitorHub.dao.OrderDAO;
import com.MonitorHub.model.Order;
import com.MonitorHub.model.Product;
import com.MonitorHub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/order/place")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(OrderServlet.class.getName());

    private MonitorDAO monitorDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        monitorDAO = new MonitorDAO();
        orderDAO = new OrderDAO();
        LOGGER.info("OrderServlet initialized with DAOs.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null) {
            LOGGER.warning("Unauthorized order attempt: User not logged in.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\": false, \"message\": \"You must be logged in to place an order.\"}");
            out.flush();
            return;
        }

        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        int productId;
        int quantity;

        try {
            if (productIdStr == null || productIdStr.trim().isEmpty() ||
                quantityStr == null || quantityStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Product ID and quantity are required.");
            }
            productId = Integer.parseInt(productIdStr);
            quantity = Integer.parseInt(quantityStr);
            if (quantity <= 0) {
                throw new IllegalArgumentException("Quantity must be greater than zero.");
            }
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid order input: " + e.getMessage(), e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
            out.flush();
            return;
        }

        Connection conn = null;
        try {
            Product productToOrder = monitorDAO.getMonitorById(productId);

            if (productToOrder == null) {
                LOGGER.warning("Order attempt for non-existent product ID: " + productId);
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\": false, \"message\": \"The selected product could not be found.\"}");
                out.flush();
                return;
            }

            // Use getPrice() which should determine if discounted or original is applicable
            BigDecimal pricePerUnitAtOrder = productToOrder.getPrice();
            if (pricePerUnitAtOrder == null || pricePerUnitAtOrder.compareTo(BigDecimal.ZERO) <= 0) {
                LOGGER.severe("CRITICAL: Product ID " + productToOrder.getId() + " has an invalid price: " + pricePerUnitAtOrder);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"message\": \"Error retrieving product price.\"}");
                out.flush();
                return;
            }

            // Check stock *before* starting transaction
            if (productToOrder.getStock_quantity() < quantity) {
                LOGGER.info("Order attempt for product ID " + productId + " failed due to insufficient stock. Requested: " + quantity + ", Available: " + productToOrder.getStock_quantity());
                response.setStatus(HttpServletResponse.SC_CONFLICT); // 409 Conflict is appropriate for stock issues
                out.print("{\"success\": false, \"message\": \"Not enough stock. Only " + productToOrder.getStock_quantity() + " left.\"}");
                out.flush();
                return;
            }

            conn = DatabaseConfig.getConnection();
            if (conn == null) {
                throw new SQLException("Failed to obtain database connection.");
            }
            conn.setAutoCommit(false); // Start transaction

            BigDecimal totalPrice = pricePerUnitAtOrder.multiply(BigDecimal.valueOf(quantity));
            String userNameForOrder = loggedInUser.getFirstname() + " " + loggedInUser.getLastname();
            
            // Create Order object
            Order newOrder = new Order();
            newOrder.setUserId(loggedInUser.getUserid());
            newOrder.setUserName(userNameForOrder); // Set customer name
            newOrder.setProductId(productId);
            newOrder.setProductName(productToOrder.getName()); // Set product name
            newOrder.setQuantity(quantity);
            newOrder.setPricePerUnit(pricePerUnitAtOrder);
            newOrder.setTotalPrice(totalPrice);
            newOrder.setOrderDate(LocalDateTime.now()); // Set order date to current time
            newOrder.setStatus("Pending"); // Initial status

            // Save the order
            long generatedSaleId = orderDAO.saveOrder(newOrder, conn);
            newOrder.setOrderId((int) generatedSaleId); // **UPDATE: Set the actual ID from the database**

            // Update stock quantity
            int newStock = productToOrder.getStock_quantity() - quantity;
            boolean stockUpdated = monitorDAO.updateStockQuantity(productId, newStock, conn);

            if (!stockUpdated) {
                // This could happen if stock was updated by another transaction between initial check and now,
                // or if product was deleted. The transaction will be rolled back.
                throw new SQLException("Failed to update product stock. Product might be unavailable or stock changed concurrently.");
            }

            conn.commit(); // Commit transaction
            LOGGER.info("Order transaction committed. Sale ID: " + generatedSaleId + ", Product ID: " + productId + ", User ID: " + loggedInUser.getUserid() + ", Stock updated to: " + newStock);

            // Send success response
            response.setStatus(HttpServletResponse.SC_OK); // Or SC_CREATED (201)
            out.print("{\"success\": true, \"message\": \"Order placed successfully! Order ID: #" + generatedSaleId + "\", \"orderId\": " + generatedSaleId + "}");
            out.flush();

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database transaction error during order placement: " + e.getMessage(), e);
            if (conn != null) {
                try {
                    LOGGER.info("Rolling back order transaction due to SQLException.");
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction after SQLException", ex);
                }
            }
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"A database error occurred while placing your order. Please try again.\"}");
            out.flush();
        } catch (IllegalArgumentException e) { // Catch specific validation errors
            LOGGER.log(Level.WARNING, "Invalid argument during order placement: " + e.getMessage(), e);
            // No rollback needed as transaction hasn't started or should be handled if it did
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
            out.flush();
        } catch (Exception e) { // Catch any other unexpected errors
            LOGGER.log(Level.SEVERE, "Unexpected error during order placement: " + e.getMessage(), e);
            if (conn != null) {
                try {
                    LOGGER.info("Rolling back order transaction due to general Exception.");
                    conn.rollback(); // Rollback if transaction was started
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction after general Exception", ex);
                }
            }
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"An unexpected error occurred. Please try again.\"}");
            out.flush();
        } finally {
            if (conn != null) {
                try {
                    if (!conn.getAutoCommit()) { // Only set back if we changed it
                        conn.setAutoCommit(true);
                    }
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection in OrderServlet finally block", e);
                }
            }
            if (out != null) {
                out.close(); // Close PrintWriter
            }
        }
    }
}