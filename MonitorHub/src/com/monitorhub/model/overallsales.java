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
public class overallsales {
    private String brandName;
    private String modelName;
    private String monitorType;
    private String partyName;
    private String date;
    private int quantity;
    private int rate;
    private int amount;
    
    /**
     * Constructor for the overallsales class.
     *
     * @param brandName   The brand name of the product.
     * @param modelName   The model name of the product.
     * @param monitorType The type of the monitor.
     * @param partyName   The name of the party involved in the sale.
     * @param date        The date of the transaction.
     * @param quantity    The quantity of products sold.
     * @param rate        The rate (price per unit).
     * @param amount      The total amount (quantity * rate).
     */
    public overallsales(String brandName, String modelName, String monitorType, String partyName, String date, int quantity, int rate, int amount) {
        this.brandName = brandName;
        this.modelName = modelName;
        this.monitorType = monitorType;
        this.partyName = partyName;
        this.date = date;
        this.quantity = quantity;
        this.rate = rate;
        this.amount = amount;
    }

    /**
     * Gets the brand name of the product.
     *
     * @return The brand name.
     */
    public String getBrandName() {
        return brandName;
    }

    /**
     * Sets the brand name of the product.
     *
     * @param brandName The brand name to set.
     */
    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    /**
     * Gets the model name of the product.
     *
     * @return The model name.
     */
    public String getModelName() {
        return modelName;
    }

    /**
     * Sets the model name of the product.
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
     * Gets the name of the party involved in the sale.
     *
     * @return The party name.
     */
    public String getPartyName() {
        return partyName;
    }

    /**
     * Sets the name of the party involved in the sale.
     *
     * @param partyName The party name to set.
     */
    public void setPartyName(String partyName) {
        this.partyName = partyName;
    }

    /**
     * Gets the date of the sales transaction.
     *
     * @return The date.
     */
    public String getDate() {
        return date;
    }

    /**
     * Sets the date of the sales transaction.
     *
     * @param date The date to set.
     */
    public void setDate(String date) {
        this.date = date;
    }

    /**
     * Gets the quantity of products sold.
     *
     * @return The quantity.
     */
    public int getQuantity() {
        return quantity;
    }

    /**
     * Sets the quantity of products sold.
     *
     * @param quantity The quantity to set.
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /**
     * Gets the rate (price per unit) of the product.
     *
     * @return The rate.
     */
    public int getRate() {
        return rate;
    }

    /**
     * Sets the rate (price per unit) of the product.
     *
     * @param rate The rate to set.
     */
    public void setRate(int rate) {
        this.rate = rate;
    }

    /**
     * Gets the total amount for the transaction.
     *
     * @return The total amount.
     */
    public int getAmount() {
        return amount;
    }

    /**
     * Sets the total amount for the transaction.
     *
     * @param amount The total amount to set.
     */
    public void setAmount(int amount) {
        this.amount = amount;
    }
    
}
