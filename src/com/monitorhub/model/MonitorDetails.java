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
    


    // Constructor
    public MonitorDetails(String brandName, String modelName, String modelType, int stock, int rate, int amount) {
        this.brandName = brandName;
        this.modelName = modelName;
        this.monitorType = modelType;
        this.stock = stock;
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

    public void setModelType(String monitorType) {
        this.monitorType = monitorType;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
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

