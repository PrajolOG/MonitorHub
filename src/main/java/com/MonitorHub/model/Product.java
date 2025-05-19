package com.MonitorHub.model;

import java.math.BigDecimal;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicInteger;

public class Product {

    private static final AtomicInteger idCounter = new AtomicInteger(100);

    private int id;
    private String name;
    private String brand;
    private String model;
    private String imageUrl;
    private String description;
    private String type;
    private int stock_quantity;
    private BigDecimal original_price;
    private BigDecimal discounted_price;
    private String delivery_info;

    public Product() {
        this.original_price = BigDecimal.ZERO;
    }

    public Product(String name, String brand, String model, String imageUrl, String description,
                   String type, int stock_quantity, BigDecimal original_price,
                   BigDecimal discounted_price, String delivery_info) {
        this.id = idCounter.incrementAndGet();
        this.name = name;
        this.brand = brand;
        this.model = model;
        this.imageUrl = imageUrl;
        this.description = description;
        this.type = type;
        this.stock_quantity = stock_quantity;
        this.original_price = original_price;
        this.discounted_price = discounted_price;
        this.delivery_info = delivery_info;
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }
    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }
    public void setModel(String model) {
        this.model = model;
    }

    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }

    public int getStock_quantity() {
        return stock_quantity;
    }
    public void setStock_quantity(int stock_quantity) {
        this.stock_quantity = stock_quantity;
    }

    public BigDecimal getOriginal_price() {
        return original_price;
    }
    public void setOriginal_price(BigDecimal original_price) {
        this.original_price = original_price;
    }

    public BigDecimal getDiscounted_price() {
        return discounted_price;
    }
    public void setDiscounted_price(BigDecimal discounted_price) {
        this.discounted_price = discounted_price;
    }

    public String getDelivery_info() {
        return delivery_info;
    }
    public void setDelivery_info(String delivery_info) {
        this.delivery_info = delivery_info;
    }

    public BigDecimal getPrice() {
        if (discounted_price != null && discounted_price.compareTo(BigDecimal.ZERO) > 0 &&
            (original_price == null || discounted_price.compareTo(original_price) < 0)) {
            return discounted_price;
        }
        return original_price != null ? original_price : BigDecimal.ZERO;
    }

    public boolean hasDiscount() {
        return discounted_price != null && discounted_price.compareTo(BigDecimal.ZERO) > 0 &&
               original_price != null && discounted_price.compareTo(original_price) < 0;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Product product = (Product) o;
        return id == product.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "Product{id=" + id + ", name='" + name + '\'' + '}';
    }
}