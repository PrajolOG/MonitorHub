package com.MonitorHub.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DatabaseConfig {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/monitorhub?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; 
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    private static final Logger LOGGER = Logger.getLogger(DatabaseConfig.class.getName());

    // Static block to load the driver when the class is loaded
    static {
        try {
            Class.forName(DB_DRIVER);
            LOGGER.info("MySQL JDBC Driver Registered!");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found!", e);
            throw new RuntimeException("Failed to register JDBC Driver", e);
        }
    }

    /**
     * Gets a connection to the database.
     *
     * @return Connection object or null if connection fails.
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            LOGGER.fine("Database connection established.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database Connection Failed!", e);
            throw e;
        }
        return connection;
    }

    /**
     * Closes database resources safely.
     *
     * @param connection Connection to close.
     * @param statement Statement to close.
     * @param resultSet ResultSet to close.
     */
    public static void closeResources(Connection connection, Statement statement, ResultSet resultSet) {
        try {
            if (resultSet != null) {
                resultSet.close();
                LOGGER.finer("ResultSet closed.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error closing ResultSet", e);
        }
        try {
            if (statement != null) {
                statement.close();
                 LOGGER.finer("Statement closed.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error closing Statement", e);
        }
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                 LOGGER.fine("Database connection closed.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error closing Connection", e);
        }
    }

     /**
     * Closes connection and prepared statement.
     */
    public static void closeResources(Connection connection, PreparedStatement preparedStatement) {
        closeResources(connection, preparedStatement, null);
    }

    /**
     * Closes connection and statement.
     */
    public static void closeResources(Connection connection, Statement statement) {
        closeResources(connection, statement, null);
    }
}