package com.MonitorHub.dao;

import com.MonitorHub.config.DatabaseConfig;
import com.MonitorHub.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public List<User> getAllUsersWithRolesFromDB() throws SQLException {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT u.userid, u.firstname, u.lastname, u.email, u.phone, u.created_at, MAX(r.role_name) AS role_name, MAX(img.image_url) AS image_url FROM Users u LEFT JOIN UserRoles ur ON u.userid = ur.userid LEFT JOIN Roles r ON ur.roleid = r.roleid LEFT JOIN UserImages ui ON u.userid = ui.userid AND ui.image_type = 'profile' LEFT JOIN Images img ON ui.imageid = img.imageid GROUP BY u.userid, u.firstname, u.lastname, u.email, u.phone, u.created_at ORDER BY u.userid ASC";
        try (Connection conn = DatabaseConfig.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (conn == null) throw new SQLException("DB connection failed.");
            while (rs.next()) {
                User user = new User();
                user.setUserid(rs.getInt("userid"));
                user.setFirstname(rs.getString("firstname"));
                user.setLastname(rs.getString("lastname"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setRoleName(rs.getString("role_name"));
                user.setImageUrl(rs.getString("image_url"));
                userList.add(user);
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error fetching users with roles", e); throw e; }
        return userList;
    }
    public boolean deleteUserFromDB(int userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE userid = ?"; boolean deleted = false;
        try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (conn == null) throw new SQLException("DB connection failed.");
            pstmt.setInt(1, userId);
            deleted = (pstmt.executeUpdate() > 0);
        } catch (SQLException e) { if (e.getSQLState().startsWith("23")) return false; else throw e; }
        return deleted;
    }

    /**
     * Gets the total count of users from the Users table.
     * @return The total number of users.
     * @throws SQLException if a database error occurs.
     */
    public int getTotalUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) AS total_users FROM Users";
        int totalUsers = 0;
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (conn == null) throw new SQLException("Database connection failed.");
            if (rs.next()) {
                totalUsers = rs.getInt("total_users");
            }
            LOGGER.info("Total users count from DB: " + totalUsers);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total user count", e);
            throw e;
        }
        return totalUsers;
    }

    /**
     * Fetches a single user by ID, including their primary role and profile image URL.
     * @param userId The ID of the user to fetch.
     * @return User object or null if not found.
     * @throws SQLException
     */
    public User getUserById(int userId) throws SQLException {
        User user = null;
        String sql = "SELECT u.userid, u.firstname, u.lastname, u.email, u.phone, u.created_at, " +
                     "MAX(r.role_name) AS role_name, MAX(img.image_url) AS image_url " +
                     "FROM Users u " +
                     "LEFT JOIN UserRoles ur ON u.userid = ur.userid " +
                     "LEFT JOIN Roles r ON ur.roleid = r.roleid " +
                     "LEFT JOIN UserImages ui ON u.userid = ui.userid AND ui.image_type = 'profile' " +
                     "LEFT JOIN Images img ON ui.imageid = img.imageid " +
                     "WHERE u.userid = ? " +
                     "GROUP BY u.userid, u.firstname, u.lastname, u.email, u.phone, u.created_at";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (conn == null) throw new SQLException("Database connection failed.");
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserid(rs.getInt("userid"));
                    user.setFirstname(rs.getString("firstname"));
                    user.setLastname(rs.getString("lastname"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setRoleName(rs.getString("role_name"));
                    user.setImageUrl(rs.getString("image_url"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user by ID: " + userId, e);
            throw e;
        }
        return user;
    }
}