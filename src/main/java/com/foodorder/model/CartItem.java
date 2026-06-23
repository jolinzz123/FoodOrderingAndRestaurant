package com.foodorder.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class CartItem implements Serializable {
    private int foodId;
    private String foodName;
    private BigDecimal unitPrice;
    private int quantity;
    private String addons;       // comma-separated addon names
    private BigDecimal addonsPrice;

    public CartItem() {}

    public CartItem(int foodId, String foodName, BigDecimal unitPrice, int quantity, String addons, BigDecimal addonsPrice) {
        this.foodId = foodId;
        this.foodName = foodName;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.addons = addons;
        this.addonsPrice = addonsPrice;
    }

    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }

    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getAddons() { return addons; }
    public void setAddons(String addons) { this.addons = addons; }

    public BigDecimal getAddonsPrice() { return addonsPrice; }
    public void setAddonsPrice(BigDecimal addonsPrice) { this.addonsPrice = addonsPrice; }

    public BigDecimal getSubtotal() {
        BigDecimal base = unitPrice.add(addonsPrice == null ? BigDecimal.ZERO : addonsPrice);
        return base.multiply(new BigDecimal(quantity));
    }
}
