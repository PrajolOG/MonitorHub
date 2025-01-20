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

    /**
     * Checks if a given string represents a valid stock quantity.
     *
     * A valid stock quantity is a positive integer that does not exceed 500.
     *
     * @param stockText The string to be validated.
     * @return `true` if the string is a valid stock quantity, `false` otherwise.
     */
    public static boolean isValidStock(String stockText) {
        try {
            int stock = Integer.parseInt(stockText);
            return stock > 0 && stock <= 500; // Check if within the valid range
        } catch (NumberFormatException e) {
            return false;
        }
    }

    
    
    
    /**
     * Checks if a given string represents a valid rate (price).
     *
     * A valid rate is a positive integer between 100 and 1500.
     *
     * @param rateText The string to be validated.
     * @return `true` if the string is a valid rate, `false` otherwise.
     */
    public static boolean isValidRate(String rateText) {
        try {
            int rate = Integer.parseInt(rateText);
            return rate > 100 && rate <= 1500; // Check if within the valid range
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    
    
    
    /**
     * Validates all input fields for adding or updating monitor stock.
     *
     * This method checks if any of the provided strings (brand name, model name, monitor type,
     * stock, or rate) are either `null` or empty.
     *
     * @param brandName   The brand name of the monitor.
     * @param modelName   The model name of the monitor.
     * @param monitorType The type of the monitor.
     * @param stockText   The stock quantity as a string.
     * @param rateText    The rate (price) as a string.
     * @return `true` if all inputs are valid (not null or empty), `false` otherwise.
     */
    public static boolean validateInput(String brandName, String modelName, String monitorType, String stockText, String rateText) {
        // 1. Check for null or empty values
        if (brandName == null || brandName.isEmpty() ||
            modelName == null || modelName.isEmpty() ||
            monitorType == null || monitorType.isEmpty() ||
            stockText == null || stockText.isEmpty() ||
            rateText == null || rateText.isEmpty()) {
            return false; // Any input is empty or null
        }

        return true; // All validations passed
    }
      
    
    
    
    
    /**
     * Checks if a given model name and monitor type combination already exists in a table.
     *
     * This method iterates through the rows of a `DefaultTableModel` to determine if a
     * specific combination of model name and monitor type is already present.
     *
     * @param modelName   The model name to search for.
     * @param monitorType The monitor type to search for.
     * @param model       The `DefaultTableModel` representing the table data.
     * @return true if the model name and monitor type combination exists, `false` otherwise.
     */
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