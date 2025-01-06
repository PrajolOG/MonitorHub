package com.monitorhub.util;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Prajol Bimali
 * LMU ID: 23048651
 */


import javax.swing.table.DefaultTableModel;



public class ValidationUtil {

    // Method to check if stock is a valid positive number
    public static boolean isValidStock(String stockText) {
        try {
            int stock = Integer.parseInt(stockText);
            return stock > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    // Method to check if price is a valid positive number
    public static boolean isValidrate(String rateText) {
        try {
            int rate = Integer.parseInt(rateText);
            return rate > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    // Method to check for duplicate Model Name and Monitor Type in the table
    public static boolean isDuplicateModelType(String modelName, String monitorType, DefaultTableModel model) {
        int rowCount = model.getRowCount();
        for (int i = 0; i < rowCount; i++) {
            String existingModelName = model.getValueAt(i, 1).toString();
            String existingMonitorType = model.getValueAt(i, 2).toString();

            if (existingModelName.equalsIgnoreCase(modelName) &&
                existingMonitorType.equalsIgnoreCase(monitorType)) {
                return true; // Duplicate found
            }
        }
        return false; // No duplicates
    }

    // Method to validate all inputs
    public static boolean validateInputs(String brandName, String modelName, String monitorType, String stockText, String rateText) {
        if (brandName == null || brandName.isEmpty() ||
            modelName == null || modelName.isEmpty() ||
            monitorType == null || monitorType.isEmpty() ||
            stockText == null || stockText.isEmpty() ||
            rateText == null || rateText.isEmpty()) {
            return false; // Any input is empty or null
        }

        return isValidStock(stockText) && isValidrate(rateText); // Validate stock and price
    }
    
    // Validates that none of the fields are null or empty
    public static boolean validateFields(String brandName, String modelName, String monitorType, String stockText, String rateText) {
        return brandName != null && modelName != null && monitorType != null &&
               stockText != null && !stockText.isEmpty() &&
               rateText != null && !rateText.isEmpty();
    }
    
    
    
    // Validates the input fields for the Update button
    public static boolean validateUpdateInputs(String brandName, String modelName, String monitorType, String stockText, String rateText) {
        // Check if fields are properly filled
        if (!validateFields(brandName, modelName, monitorType, stockText, rateText)) {
            return false;
        }

        try {
            // Validate stock and price
            if (!isValidStock(stockText) || !isValidrate(rateText)) {
                return false;
            }
        } catch (NumberFormatException e) {
            return false; // Stock or price is not a valid number
        }

        return true; // All validations passed
    }
    
        // Method to check if the Model Name and Monitor Type already exist in the table (for adding)
    public static boolean modelTypeExists(String modelName, String monitorType, DefaultTableModel model) {
        int rowCount = model.getRowCount();
        for (int i = 0; i < rowCount; i++) {
            String existingModelName = model.getValueAt(i, 1).toString();
            String existingMonitorType = model.getValueAt(i, 2).toString();

            if (existingModelName.equalsIgnoreCase(modelName) &&
                    existingMonitorType.equalsIgnoreCase(monitorType)) {
                return true; // Combination already exists
            }
        }
        return false; // Combination does not exist
    }  
}



