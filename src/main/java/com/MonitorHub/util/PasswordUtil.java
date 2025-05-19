package com.MonitorHub.util;

import org.mindrot.jbcrypt.BCrypt;

import java.util.logging.Level;
import java.util.logging.Logger;

public class PasswordUtil {

     private static final Logger LOGGER = Logger.getLogger(PasswordUtil.class.getName());

    /**
     * Hashes a plain text password using BCrypt.
     *
     * @param plainPassword The password to hash.
     * @return The hashed password string.
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            LOGGER.warning("Attempted to hash an empty password.");
            return null; // Or throw an exception
        }
        // The number 12 is the log2 of the number of rounds, adjust as needed (10-12 is common)
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
        LOGGER.fine("Password hashed successfully.");
        return hashedPassword;
    }

    /**
     * Checks if a plain text password matches a stored BCrypt hash.
     *
     * @param plainPassword  The plain text password to check.
     * @param hashedPassword The stored hashed password.
     * @return true if the password matches the hash, false otherwise.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null || plainPassword.isEmpty() || hashedPassword.isEmpty()) {
            LOGGER.warning("Attempted to check password with null or empty inputs.");
            return false;
        }
        boolean doesMatch = false;
        try {
             doesMatch = BCrypt.checkpw(plainPassword, hashedPassword);
             LOGGER.log(Level.FINE, "Password check result: {0}", doesMatch);
        } catch (IllegalArgumentException e) {
            // This can happen if the hash format is invalid
            LOGGER.log(Level.SEVERE, "Error checking password - invalid hash format?", e);
            return false; // Treat invalid hash as non-match
        }
        return doesMatch;
    }
}