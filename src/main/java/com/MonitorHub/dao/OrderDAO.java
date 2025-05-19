package com.MonitorHub.dao;

import com.MonitorHub.config.DatabaseConfig;
import com.MonitorHub.model.Order;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    // Method to save an order
    public long saveOrder(Order order, Connection conn) throws SQLException {
        String sql = "INSERT INTO Sales (userid, monitorid, quantity, price_paid_per_item, sale_date) VALUES (?, ?, ?, ?, ?)";
        long generatedSaleId = -1;
        PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        try {
            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getProductId());
            pstmt.setInt(3, order.getQuantity());
            pstmt.setBigDecimal(4, order.getPricePerUnit());
            // Convert LocalDateTime to Timestamp for database
            if (order.getOrderDate() != null) {
                pstmt.setTimestamp(5, Timestamp.valueOf(order.getOrderDate()));
            } else {
                pstmt.setNull(5, Types.TIMESTAMP); // Handle null orderDate
            }

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    generatedSaleId = generatedKeys.getLong(1);
                    order.setOrderId((int) generatedSaleId);
                } else {
                    throw new SQLException("Creating order failed, no ID obtained.");
                }
            }
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Failed to close PreparedStatement in saveOrder", e);
                }
            }
        }
        return generatedSaleId;
    }


    /**
     * Gets the total revenue from all sales.
     * @return Total sales revenue.
     * @throws SQLException if a database error occurs.
     */
    public BigDecimal getTotalSalesValue() throws SQLException {
        String sql = "SELECT SUM(price_paid_per_item * quantity) AS total_revenue FROM Sales";
        BigDecimal totalRevenue = BigDecimal.ZERO;
        Connection conn = null; Statement stmt = null; ResultSet rs = null;
        try {
            conn = DatabaseConfig.getConnection();
             if (conn == null) throw new SQLException("Database connection failed.");
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                totalRevenue = rs.getBigDecimal("total_revenue");
                if (totalRevenue == null) {
                    totalRevenue = BigDecimal.ZERO;
                }
            }
            LOGGER.info("Total sales revenue from DB: " + totalRevenue);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total sales value", e);
            throw e;
        } finally {
            DatabaseConfig.closeResources(conn, stmt, rs); // Uses helper
        }
        return totalRevenue;
    }

    /**
     * Retrieves the most recent N sales with customer and product details for the dashboard.
     * @param limit The number of recent sales to retrieve.
     * @return A list of Maps, each containing details for a recent order.
     * @throws SQLException if a database error occurs.
     */
    public List<Map<String, Object>> getRecentSalesForDashboard(int limit) throws SQLException {
        List<Map<String, Object>> recentSalesDetails = new ArrayList<>();
        String sql = "SELECT s.saleid, s.userid, u.firstname, u.lastname, u.email AS customerEmail, " +
                     "ui_img.image_url AS customerAvatarUrl, " +
                     "s.monitorid, m.monitor_name, s.quantity, s.price_paid_per_item, s.sale_date " +
                     "FROM Sales s " +
                     "JOIN Users u ON s.userid = u.userid " +
                     "JOIN Monitors m ON s.monitorid = m.monitorid " +
                     "LEFT JOIN UserImages ui ON u.userid = ui.userid AND ui.image_type = 'profile' " +
                     "LEFT JOIN Images ui_img ON ui.imageid = ui_img.imageid " +
                     "ORDER BY s.sale_date DESC " +
                     "LIMIT ?";
        Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
        try {
            conn = DatabaseConfig.getConnection();
             if (conn == null) throw new SQLException("Database connection failed.");
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            LOGGER.fine("Executing query: Get Recent Sales for Dashboard, limit " + limit);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", rs.getLong("saleid"));
                item.put("customerName", rs.getString("firstname") + " " + rs.getString("lastname"));
                item.put("customerEmail", rs.getString("customerEmail"));
                item.put("customerAvatarUrl", rs.getString("customerAvatarUrl"));
                Timestamp saleTimestamp = rs.getTimestamp("sale_date");
                if (saleTimestamp != null) {
                    LocalDateTime ldt = saleTimestamp.toLocalDateTime();
                    item.put("orderDate", ldt);
                    item.put("orderDateAsUtilDate", java.util.Date.from(ldt.atZone(ZoneId.systemDefault()).toInstant()));
                } else {
                    item.put("orderDate", null);
                    item.put("orderDateAsUtilDate", null);
                }
                BigDecimal pricePerItem = rs.getBigDecimal("price_paid_per_item");
                int quantity = rs.getInt("quantity");
                item.put("totalAmount", pricePerItem != null ? pricePerItem.multiply(BigDecimal.valueOf(quantity)) : BigDecimal.ZERO);
                item.put("itemCount", quantity);

                recentSalesDetails.add(item);
            }
            LOGGER.info("Fetched " + recentSalesDetails.size() + " recent sales details for dashboard.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent sales for dashboard", e);
            throw e;
        } finally {
            DatabaseConfig.closeResources(conn, pstmt, rs); // Uses helper
        }
        return recentSalesDetails;
    }

    /**
     * Retrieves all orders with customer and product details.
     * Also populates the orderDateForJsp field in the Order object.
     * @return A list of Order objects.
     * @throws SQLException if a database error occurs.
     */
    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT s.saleid, s.userid, u.firstname, u.lastname, " +
                     "s.monitorid, m.monitor_name, s.quantity, s.price_paid_per_item, s.sale_date " +
                     "FROM Sales s " +
                     "JOIN Users u ON s.userid = u.userid " +
                     "JOIN Monitors m ON s.monitorid = m.monitorid " +
                     "ORDER BY s.sale_date DESC";

        Connection conn = null; Statement stmt = null; ResultSet rs = null;
        try {
            conn = DatabaseConfig.getConnection();
             if (conn == null) throw new SQLException("Database connection failed.");
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId((int) rs.getLong("saleid"));
                order.setUserId(rs.getInt("userid"));
                order.setUserName(rs.getString("firstname") + " " + rs.getString("lastname"));
                order.setProductId(rs.getInt("monitorid"));
                order.setProductName(rs.getString("monitor_name"));
                order.setQuantity(rs.getInt("quantity"));
                order.setPricePerUnit(rs.getBigDecimal("price_paid_per_item"));

                // Calculate total price
                BigDecimal pricePerUnit = order.getPricePerUnit();
                if (pricePerUnit != null) {
                    order.setTotalPrice(pricePerUnit.multiply(BigDecimal.valueOf(order.getQuantity())));
                } else {
                    order.setTotalPrice(BigDecimal.ZERO);
                }

                // Handle LocalDateTime from Timestamp
                Timestamp saleTimestamp = rs.getTimestamp("sale_date");
                if (saleTimestamp != null) {
                    LocalDateTime saleDateTime = saleTimestamp.toLocalDateTime();
                    order.setOrderDate(saleDateTime);

                    // Convert and set the java.util.Date for JSP
                    order.setOrderDateForJsp(
                        java.util.Date.from(saleDateTime.atZone(ZoneId.systemDefault()).toInstant())
                    );
                }

                orders.add(order);
            }
            LOGGER.info("Fetched " + orders.size() + " orders from database.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all orders", e);
            throw e;
        } finally {
            DatabaseConfig.closeResources(conn, stmt, rs); // Uses helper
        }
        return orders;
    }
}