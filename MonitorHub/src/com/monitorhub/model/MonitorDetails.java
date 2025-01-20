/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.monitorhub.model;

/**
 *
 * @author Prajol Bimali
 * LMU ID: 23048651
 */
public class MonitorDetails {
    private String brandName;
    private String modelName;
    private String monitorType;
    private int stock;
    private int rate;
    private int amount;
    


    /**
     * Constructor for the MonitorDetails class.
     *
     * @param brandName   The brand name of the monitor.
     * @param modelName   The model name of the monitor.
     * @param modelType   The type of the monitor.
     * @param stock       The stock quantity of the monitor.
     * @param rate        The rate (price) of the monitor.
     * @param amount      The total amount (stock * rate).
     */
    public MonitorDetails(String brandName, String modelName, String modelType, int stock, int rate, int amount) {
        this.brandName = brandName;
        this.modelName = modelName;
        this.monitorType = modelType;
        this.stock = stock;
        this.rate = rate;
        this.amount = amount;
        
    }

    /**
     * Gets the brand name of the monitor.
     *
     * @return The brand name.
     */
    public String getBrandName() {
        return brandName;
    }

    /**
     * Sets the brand name of the monitor.
     *
     * @param brandName The brand name to set.
     */
    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    /**
     * Gets the model name of the monitor.
     *
     * @return The model name.
     */
    public String getModelName() {
        return modelName;
    }

    /**
     * Sets the model name of the monitor.
     *
     * @param modelName The model name to set.
     */
    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    /**
     * Gets the type of the monitor.
     *
     * @return The monitor type.
     */
    public String getMonitorType() {
        return monitorType;
    }

    /**
     * Sets the type of the monitor.
     *
     * @param monitorType The monitor type to set.
     */
    public void setMonitorType(String monitorType) {
        this.monitorType = monitorType;
    }

    /**
     * Gets the stock quantity of the monitor.
     *
     * @return The stock quantity.
     */
    public int getStock() {
        return stock;
    }

    /**
     * Sets the stock quantity of the monitor.
     *
     * @param stock The stock quantity to set.
     */
    public void setStock(int stock) {
        this.stock = stock;
    }

    /**
     * Gets the rate (price) of the monitor.
     *
     * @return The rate.
     */
    public int getRate() {
        return rate;
    }

    /**
     * Sets the rate (price) of the monitor.
     *
     * @param rate The rate to set.
     */
    public void setRate(int rate) {
        this.rate = rate;
    }

    /**
     * Gets the total amount (stock * rate).
     *
     * @return The total amount.
     */
    public int getAmount() {
        return amount;
    }

    /**
     * Sets the total amount.
     *
     * @param amount The total amount to set.
     */
    public void setAmount(int amount) {
        this.amount = amount;
    }

}

