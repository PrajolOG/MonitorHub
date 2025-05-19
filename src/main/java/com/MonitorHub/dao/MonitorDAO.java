// In MonitorDAO.java
package com.MonitorHub.dao;

import com.MonitorHub.config.DatabaseConfig;
import com.MonitorHub.model.Product;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MonitorDAO {

    private static final Logger LOGGER = Logger.getLogger(MonitorDAO.class.getName());
    public List<Product> getAllMonitorsWithPrimaryImage() throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT m.monitorid, m.monitor_name, m.brand, m.model, m.description, m.type, " +
                     "m.original_price, m.discounted_price, m.delivery_info, m.stock_quantity, " +
                     "img.image_url AS primary_image_url " +
                     "FROM Monitors m " +
                     "LEFT JOIN MonitorImages mi ON m.monitorid = mi.monitorid AND mi.is_primary = 1 " +
                     "LEFT JOIN Images img ON mi.imageid = img.imageid " +
                     "ORDER BY m.monitorid ASC";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (conn == null) throw new SQLException("Database connection failed.");
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                product.setImageUrl(rs.getString("primary_image_url"));
                products.add(product);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching monitors", e); throw e;
        }
        return products;
    }

    public Product getMonitorById(int monitorId) throws SQLException {
        Product product = null;
        String sql = "SELECT m.monitorid, m.monitor_name, m.brand, m.model, m.description, m.type, " +
                     "m.original_price, m.discounted_price, m.delivery_info, m.stock_quantity, " +
                     "img.image_url AS primary_image_url " +
                     "FROM Monitors m " +
                     "LEFT JOIN MonitorImages mi ON m.monitorid = mi.monitorid AND mi.is_primary = 1 " +
                     "LEFT JOIN Images img ON mi.imageid = img.imageid " +
                     "WHERE m.monitorid = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (conn == null) throw new SQLException("Database connection failed.");
            pstmt.setInt(1, monitorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    product = mapResultSetToProduct(rs);
                    product.setImageUrl(rs.getString("primary_image_url"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching monitor by ID " + monitorId, e); throw e;
        }
        return product;
    }

    public int addMonitor(Product product) throws SQLException {
        String monitorSql = "INSERT INTO Monitors (monitor_name, brand, model, description, type, original_price, discounted_price, delivery_info, stock_quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedMonitorId = -1; Connection conn = null;
        try {
            conn = DatabaseConfig.getConnection(); if (conn == null) throw new SQLException("DB connection failed.");
            conn.setAutoCommit(false);
            try (PreparedStatement pstmtMonitor = conn.prepareStatement(monitorSql, Statement.RETURN_GENERATED_KEYS)) {
                setMonitorStatementParams(pstmtMonitor, product);
                if (pstmtMonitor.executeUpdate() == 0) throw new SQLException("Creating monitor failed, no rows affected.");
                try (ResultSet generatedKeys = pstmtMonitor.getGeneratedKeys()) {
                    if (generatedKeys.next()) generatedMonitorId = generatedKeys.getInt(1);
                    else throw new SQLException("Creating monitor failed, no ID obtained.");
                }
            }
            product.setId(generatedMonitorId); // Set ID back
            if (product.getImageUrl() != null && !product.getImageUrl().trim().isEmpty()) {
                handleImageLink(conn, generatedMonitorId, product.getImageUrl(), true);
            }
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { LOGGER.log(Level.SEVERE, "Rollback failed", ex); }
            throw e;
        } finally { DbUtils.closeQuietly(conn); }
        return generatedMonitorId;
    }

    public boolean updateMonitor(Product product) throws SQLException {
        String monitorSql = "UPDATE Monitors SET monitor_name = ?, brand = ?, model = ?, description = ?, type = ?, original_price = ?, discounted_price = ?, delivery_info = ?, stock_quantity = ?, updated_at = CURRENT_TIMESTAMP WHERE monitorid = ?";
        boolean success = false; Connection conn = null;
        try {
            conn = DatabaseConfig.getConnection(); if (conn == null) throw new SQLException("DB connection failed.");
            conn.setAutoCommit(false);
            try (PreparedStatement pstmtMonitor = conn.prepareStatement(monitorSql)) {
                setMonitorStatementParams(pstmtMonitor, product);
                pstmtMonitor.setInt(10, product.getId());
                success = (pstmtMonitor.executeUpdate() > 0);
            }
            if (success) {
                removeImageLink(conn, product.getId(), true); // Remove old primary
                if (product.getImageUrl() != null && !product.getImageUrl().trim().isEmpty()) {
                    handleImageLink(conn, product.getId(), product.getImageUrl(), true);
                }
                conn.commit();
            } else { conn.rollback(); }
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { LOGGER.log(Level.SEVERE, "Rollback failed", ex); }
            throw e;
        } finally { DbUtils.closeQuietly(conn); }
        return success;
    }

    public boolean deleteMonitor(int monitorId) throws SQLException {
        String sql = "DELETE FROM Monitors WHERE monitorid = ?"; boolean deleted = false;
        try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (conn == null) throw new SQLException("DB connection failed.");
            pstmt.setInt(1, monitorId);
            deleted = (pstmt.executeUpdate() > 0);
        } catch (SQLException e) {
            if (e.getSQLState().startsWith("23")) { return false; } else { throw e; }
        }
        return deleted;
    }

    /**
     * Gets the sum of stock_quantity for all monitors.
     * @return Total stock quantity.
     * @throws SQLException if a database error occurs.
     */
    public int getTotalStockQuantity() throws SQLException {
        String sql = "SELECT SUM(stock_quantity) AS total_stock FROM Monitors";
        int totalStock = 0;
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (conn == null) throw new SQLException("Database connection failed.");
            if (rs.next()) {
                totalStock = rs.getInt("total_stock");
            }
            LOGGER.info("Total stock quantity: " + totalStock);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total stock quantity", e);
            throw e;
        }
        return totalStock;
    }

    /**
     * Fetches the top N best-selling monitors with their sales count and essential details.
     * Returns a List of Maps, where each map represents a product and its sales data.
     * @param limit The number of top-selling monitors to retrieve.
     * @return A list of Maps, each containing "name", "imageUrl", "category", "salesCount", "price".
     * @throws SQLException if a database error occurs.
     */
    public List<Map<String, Object>> getBestSellingMonitorsWithDetails(int limit) throws SQLException {
        List<Map<String, Object>> bestSellersDetails = new ArrayList<>();
        String sql = "SELECT m.monitorid, m.monitor_name, m.type, m.original_price, m.discounted_price, " +
                     "SUM(s.quantity) AS total_sold, " + // This is the sales count
                     "img.image_url AS primary_image_url " +
                     "FROM Monitors m " +
                     "JOIN Sales s ON m.monitorid = s.monitorid " + // JOIN with Sales table
                     "LEFT JOIN MonitorImages mi ON m.monitorid = mi.monitorid AND mi.is_primary = 1 " +
                     "LEFT JOIN Images img ON mi.imageid = img.imageid " +
                     "GROUP BY m.monitorid, m.monitor_name, m.type, m.original_price, m.discounted_price, img.image_url " +
                     "ORDER BY total_sold DESC " +
                     "LIMIT ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (conn == null) throw new SQLException("Database connection failed.");
            pstmt.setInt(1, limit);
            LOGGER.fine("Executing query: Get Best Selling Monitors with Details, limit " + limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("name", rs.getString("monitor_name"));
                    item.put("imageUrl", rs.getString("primary_image_url"));
                    item.put("category", rs.getString("type")); // Using monitor 'type' as category
                    item.put("salesCount", rs.getInt("total_sold"));

                    BigDecimal originalPrice = rs.getBigDecimal("original_price");
                    BigDecimal discountedPrice = rs.getBigDecimal("discounted_price");
                    BigDecimal displayPrice = originalPrice; // Default to original price
                    if (discountedPrice != null && discountedPrice.compareTo(BigDecimal.ZERO) > 0 && discountedPrice.compareTo(originalPrice) < 0) {
                        displayPrice = discountedPrice;
                    }
                    item.put("price", displayPrice);
                    
                    bestSellersDetails.add(item);
                }
            }
            LOGGER.info("Fetched " + bestSellersDetails.size() + " best-selling monitor details.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting best-selling monitors with details", e);
            throw e;
        }
        return bestSellersDetails;
    }
    
    // Helper method to update stock within a transaction (already provided, ensure it's here)
    public boolean updateStockQuantity(int monitorId, int newStockQuantity, Connection conn) throws SQLException {
        if (newStockQuantity < 0) {
             LOGGER.warning("Attempted to set negative stock ("+ newStockQuantity +") for monitor ID " + monitorId);
             throw new SQLException("Stock quantity cannot be negative.");
        }
        String sql = "UPDATE Monitors SET stock_quantity = ?, updated_at = CURRENT_TIMESTAMP WHERE monitorid = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, newStockQuantity);
            pstmt.setInt(2, monitorId);
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                 LOGGER.fine("Stock updated for monitor ID " + monitorId + " to " + newStockQuantity);
                 return true;
            } else {
                 LOGGER.warning("Failed to update stock for monitor ID " + monitorId + " (monitor not found?).");
                 return false;
            }
        }
    }


    // --- Helper Methods for image handling and mapping (from previous full MonitorDAO.java) ---
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("monitorid"));
        product.setName(rs.getString("monitor_name"));
        product.setBrand(rs.getString("brand"));
        product.setModel(rs.getString("model"));
        product.setDescription(rs.getString("description"));
        product.setType(rs.getString("type"));
        product.setOriginal_price(rs.getBigDecimal("original_price"));
        product.setDiscounted_price(rs.getBigDecimal("discounted_price"));
        product.setDelivery_info(rs.getString("delivery_info"));
        product.setStock_quantity(rs.getInt("stock_quantity"));
        return product;
    }

    private void setMonitorStatementParams(PreparedStatement pstmt, Product product) throws SQLException {
        pstmt.setString(1, product.getName());
        pstmt.setString(2, product.getBrand());
        pstmt.setString(3, product.getModel());
        pstmt.setString(4, product.getDescription());
        pstmt.setString(5, product.getType());
        pstmt.setBigDecimal(6, product.getOriginal_price());
        if (product.getDiscounted_price() != null && product.getDiscounted_price().compareTo(BigDecimal.ZERO) > 0) {
            pstmt.setBigDecimal(7, product.getDiscounted_price());
        } else {
            pstmt.setNull(7, Types.DECIMAL);
        }
        pstmt.setString(8, product.getDelivery_info());
        pstmt.setInt(9, product.getStock_quantity());
    }

    private void handleImageLink(Connection conn, int monitorId, String imageUrl, boolean isPrimary) throws SQLException {
        int imageId = findOrInsertImage(conn, imageUrl, "Monitor Image: " + monitorId); // Pass a description
        if (imageId > 0) {
            linkMonitorToImage(conn, monitorId, imageId, isPrimary);
        }
    }

    private int findOrInsertImage(Connection conn, String imageUrl, String description) throws SQLException {
        String findSql = "SELECT imageid FROM Images WHERE image_url = ?";
        String insertSql = "INSERT INTO Images (image_url, description) VALUES (?, ?)";
        int imageId = -1;
        try (PreparedStatement findPstmt = conn.prepareStatement(findSql)) {
            findPstmt.setString(1, imageUrl);
            try (ResultSet rs = findPstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("imageid");
                }
            }
        }
        try (PreparedStatement insertPstmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            insertPstmt.setString(1, imageUrl);
            insertPstmt.setString(2, description);
            if (insertPstmt.executeUpdate() > 0) {
                try (ResultSet genKeys = insertPstmt.getGeneratedKeys()) {
                    if (genKeys.next()) imageId = genKeys.getInt(1);
                }
            }
        }
        if (imageId <= 0) throw new SQLException("Could not obtain image ID for URL: " + imageUrl);
        return imageId;
    }

    private void linkMonitorToImage(Connection conn, int monitorId, int imageId, boolean isPrimary) throws SQLException {
        String linkSql = "INSERT IGNORE INTO MonitorImages (monitorid, imageid, is_primary) VALUES (?, ?, ?)";
        try (PreparedStatement linkPstmt = conn.prepareStatement(linkSql)) {
            linkPstmt.setInt(1, monitorId);
            linkPstmt.setInt(2, imageId);
            linkPstmt.setInt(3, isPrimary ? 1 : 0);
            linkPstmt.executeUpdate();
        }
    }

    private void removeImageLink(Connection conn, int monitorId, boolean onlyPrimary) throws SQLException {
        String sql = "DELETE FROM MonitorImages WHERE monitorid = ?";
        if (onlyPrimary) sql += " AND is_primary = 1";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, monitorId);
            pstmt.executeUpdate();
        }
    }

    private static class DbUtils {
        public static void closeQuietly(Connection conn) {
            if (conn != null) {
                try {
                    if (!conn.getAutoCommit()) conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) { /* ignore */ }
            }
        }
    }
    
    /**
     * Searches for monitors by name, brand, or model.
     * Returns a list of products with their ID, name, model, and primary image URL.
     * @param query The search term.
     * @param limit The maximum number of results to return.
     * @return A list of Product objects (partially populated for search results).
     * @throws SQLException if a database error occurs.
     */
    public List<Product> searchMonitorsByNameBrandModel(String query, int limit) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT m.monitorid, m.monitor_name, m.model, img.image_url AS primary_image_url " +
                     "FROM Monitors m " +
                     "LEFT JOIN MonitorImages mi ON m.monitorid = mi.monitorid AND mi.is_primary = 1 " +
                     "LEFT JOIN Images img ON mi.imageid = img.imageid " +
                     "WHERE m.monitor_name LIKE ? OR m.brand LIKE ? OR m.model LIKE ? " +
                     "ORDER BY CASE " +
                     "    WHEN m.monitor_name LIKE ? THEN 1 " +
                     "    WHEN m.brand LIKE ? THEN 2 " +
                     "    WHEN m.model LIKE ? THEN 3 " +
                     "    ELSE 4 " +
                     "END, m.monitor_name " +
                     "LIMIT ?";

        String searchQueryLike = "%" + query + "%"; // For general LIKE
        String searchQueryStart = query + "%";     // For prioritizing start matches

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (conn == null) throw new SQLException("Database connection failed for search.");

            pstmt.setString(1, searchQueryLike);
            pstmt.setString(2, searchQueryLike);
            pstmt.setString(3, searchQueryLike);
            pstmt.setString(4, searchQueryStart);
            pstmt.setString(5, searchQueryStart);
            pstmt.setString(6, searchQueryStart);
            pstmt.setInt(7, limit);

            LOGGER.fine("Executing search with query: " + query + ", limit: " + limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setId(rs.getInt("monitorid"));
                    product.setName(rs.getString("monitor_name"));
                    product.setModel(rs.getString("model"));
                    product.setImageUrl(rs.getString("primary_image_url"));
                    products.add(product);
                }
            }
            LOGGER.info("Search for '" + query + "' found " + products.size() + " results.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching monitors for query: " + query, e);
            throw e;
        }
        return products;
    }
}