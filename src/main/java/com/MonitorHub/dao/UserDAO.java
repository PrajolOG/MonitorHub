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
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
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
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching users with roles", e);
            throw e;
        }
        return userList;
    }

    public boolean deleteUserFromDB(int userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE userid = ?";
        boolean deleted = false;
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (conn == null) throw new SQLException("DB connection failed.");
            pstmt.setInt(1, userId);
            deleted = (pstmt.executeUpdate() > 0);
        } catch (SQLException e) {
            if (e.getSQLState() != null && e.getSQLState().startsWith("23")) {
                LOGGER.log(Level.WARNING, "Attempted to delete user with dependent records: UserID " + userId, e);
                return false;
            } else {
                LOGGER.log(Level.SEVERE, "Error deleting user: UserID " + userId, e);
                throw e;
            }
        }
        return deleted;
    }

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

    public boolean checkEmailExists(String email) throws SQLException {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT 1 FROM Users WHERE email = ? LIMIT 1";
        boolean exists = false;
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (conn == null) throw new SQLException("Database connection failed.");
            pstmt.setString(1, email.trim());
            try (ResultSet rs = pstmt.executeQuery()) {
                exists = rs.next();
            }
            LOGGER.log(Level.FINE, "Email exists check for {0}: {1}", new Object[]{email, exists});
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if email exists: " + email, e);
            throw e;
        }
        return exists;
    }

    public Integer createUserWithRole(User user, String roleName) {
        LOGGER.log(Level.INFO, "[createUserWithRole] Starting for email: {0}, role: {1}", new Object[]{user.getEmail(), roleName});
        Connection conn = null;
        PreparedStatement pstmtUser = null;
        PreparedStatement pstmtGetRole = null;
        PreparedStatement pstmtUserRole = null;
        ResultSet generatedKeys = null;
        ResultSet rsRole = null;
        Integer userId = null;

        String sqlInsertUser = "INSERT INTO Users (firstname, lastname, email, phone, password_hash) VALUES (?, ?, ?, ?, ?)";
        String sqlGetRoleId = "SELECT roleid FROM Roles WHERE role_name = ?";
        String sqlInsertUserRole = "INSERT INTO UserRoles (userid, roleid) VALUES (?, ?)";

        try {
            conn = DatabaseConfig.getConnection();
            if (conn == null) {
                LOGGER.severe("[createUserWithRole] Database connection failed.");
                return null;
            }
            conn.setAutoCommit(false); 
            LOGGER.info("[createUserWithRole] Transaction started.");

            pstmtUser = conn.prepareStatement(sqlInsertUser, Statement.RETURN_GENERATED_KEYS);
            pstmtUser.setString(1, user.getFirstname());
            pstmtUser.setString(2, user.getLastname());
            pstmtUser.setString(3, user.getEmail());
            pstmtUser.setString(4, user.getPhone());
            pstmtUser.setString(5, user.getPasswordHash());
            int affectedRows = pstmtUser.executeUpdate();
            LOGGER.log(Level.INFO, "[createUserWithRole] User INSERT affected rows: {0}", affectedRows);

            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }

            generatedKeys = pstmtUser.getGeneratedKeys();
            if (generatedKeys.next()) {
                userId = generatedKeys.getInt(1);
                user.setUserid(userId);
                LOGGER.log(Level.INFO, "[createUserWithRole] Generated User ID: {0}", userId);
            } else {
                throw new SQLException("Creating user failed, no ID obtained.");
            }

            pstmtGetRole = conn.prepareStatement(sqlGetRoleId);
            pstmtGetRole.setString(1, roleName);
            rsRole = pstmtGetRole.executeQuery();
            int roleId = -1;
            if (rsRole.next()) {
                roleId = rsRole.getInt("roleid");
                LOGGER.log(Level.INFO, "[createUserWithRole] Found Role ID: {0} for Role: {1}", new Object[]{roleId, roleName});
            } else {
                LOGGER.log(Level.SEVERE, "[createUserWithRole] Role '{0}' not found!", roleName);
                throw new SQLException("Role '" + roleName + "' not found.");
            }
            DatabaseConfig.closeResources(null, pstmtGetRole, rsRole); 

            pstmtUserRole = conn.prepareStatement(sqlInsertUserRole);
            pstmtUserRole.setInt(1, userId);
            pstmtUserRole.setInt(2, roleId);
            pstmtUserRole.executeUpdate();
            LOGGER.info("[createUserWithRole] UserRoles INSERT executed.");

            conn.commit();
            LOGGER.log(Level.INFO, "[createUserWithRole] Transaction committed successfully for user {0}", user.getEmail());

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[createUserWithRole] SQLException for " + user.getEmail() + ": " + e.getMessage(), e);
            userId = null;
            if (conn != null) {
                try {
                    conn.rollback();
                    LOGGER.warning("[createUserWithRole] Transaction rolled back.");
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "[createUserWithRole] Error rolling back transaction", ex);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[createUserWithRole] Unexpected Exception for " + user.getEmail(), e);
            userId = null;
            if (conn != null) {
                try {
                    conn.rollback();
                    LOGGER.warning("[createUserWithRole] Transaction rolled back due to unexpected exception.");
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "[createUserWithRole] Error rolling back transaction after unexpected exception", ex);
                }
            }
        } finally {
            LOGGER.info("[createUserWithRole] Closing resources...");
            DatabaseConfig.closeResources(null, pstmtUser, generatedKeys);
            DatabaseConfig.closeResources(null, pstmtUserRole, null);
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "[createUserWithRole] Error closing connection", e);
                }
            }
            LOGGER.log(Level.INFO, "[createUserWithRole] Finished for {0}. Returning UserID: {1}", new Object[]{user.getEmail(), userId});
        }
        return userId;
    }

    /**
     * Updates the profile information (firstname, lastname, phone) for a given user.
     *
     * @param userId    The ID of the user to update.
     * @param firstName The new first name.
     * @param lastName  The new last name.
     * @param phone     The new phone number (can be null or empty for optional).
     * @return true if the update was successful (at least one row affected), false otherwise.
     * @throws SQLException if a database error occurs.
     */
    public boolean updateUserProfile(int userId, String firstName, String lastName, String phone) throws SQLException {
        LOGGER.log(Level.INFO, "[updateUserProfile] Attempting to update profile for UserID: {0}", userId);
        String sql = "UPDATE Users SET firstname = ?, lastname = ?, phone = ? WHERE userid = ?";
        boolean success = false;

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (conn == null) {
                LOGGER.severe("[updateUserProfile] Database connection failed for UserID: " + userId);
                throw new SQLException("Database connection failed.");
            }

            pstmt.setString(1, firstName.trim());
            pstmt.setString(2, lastName.trim());

            if (phone != null && !phone.trim().isEmpty()) {
                pstmt.setString(3, phone.trim());
            } else {
                pstmt.setNull(3, java.sql.Types.VARCHAR);
            }
            pstmt.setInt(4, userId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                success = true;
                LOGGER.log(Level.INFO, "[updateUserProfile] Profile updated successfully for UserID: {0}. Rows affected: {1}", new Object[]{userId, rowsAffected});
            } else {
                LOGGER.log(Level.WARNING, "[updateUserProfile] Profile update for UserID: {0} resulted in 0 rows affected. User might not exist or data was unchanged.", userId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[updateUserProfile] SQLException updating profile for UserID: " + userId, e);
            throw e; // Re-throw to be handled by the servlet
        }
        return success;
    }
}