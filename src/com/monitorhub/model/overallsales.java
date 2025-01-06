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
    
    // Constructor
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
    
    // Getters and Setters
    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }
    
    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getMonitorType() {
        return monitorType;
    }

    public void setMonitorType(String monitorType) {
        this.monitorType = monitorType;
    }

    public String getPartyName() {
        return partyName;
    }

    public void setPartyName(String partyName) {
        this.partyName = partyName;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getRate() {
        return rate;
    }

    public void setRate(int rate) {
        this.rate = rate;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }
    
}
