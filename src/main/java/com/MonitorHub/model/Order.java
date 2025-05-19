package com.MonitorHub.model;

import java.math.BigDecimal;
import java.time.LocalDateTime; 
import java.util.Date;       

public class Order {
    private int orderId;
    private int userId;
    private String userName;
    private int productId;
    private String productName;
    private LocalDateTime orderDate;
    private int quantity;
    private BigDecimal pricePerUnit;
    private BigDecimal totalPrice;


    private transient Date orderDateForJsp;

    // Constructors
    public Order() {
    }

    public Order(int orderId, int userId, String userName, int productId, String productName,
                 LocalDateTime orderDate, int quantity, BigDecimal pricePerUnit, BigDecimal totalPrice) {
        this.orderId = orderId;
        this.userId = userId;
        this.userName = userName;
        this.productId = productId;
        this.productName = productName;
        this.orderDate = orderDate;
        this.quantity = quantity;
        this.pricePerUnit = pricePerUnit;
        this.totalPrice = totalPrice;
    }

    // Getters and Setters for all fields

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public LocalDateTime getOrderDate() { // Returns LocalDateTime
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) { // Accepts LocalDateTime
        this.orderDate = orderDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPricePerUnit() {
        return pricePerUnit;
    }

    public void setPricePerUnit(BigDecimal pricePerUnit) {
        this.pricePerUnit = pricePerUnit;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    // Getter and Setter for the JSP-compatible date
    public Date getOrderDateForJsp() {
        return orderDateForJsp;
    }

    public void setOrderDateForJsp(Date orderDateForJsp) {
        this.orderDateForJsp = orderDateForJsp;
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", userId=" + userId +
                ", userName='" + userName + '\'' +
                ", productId=" + productId +
                ", productName='" + productName + '\'' +
                ", orderDate=" + orderDate +
                ", quantity=" + quantity +
                ", pricePerUnit=" + pricePerUnit +
                ", totalPrice=" + totalPrice +
                '}';
    }
}