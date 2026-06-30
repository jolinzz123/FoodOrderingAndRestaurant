package com.foodorder.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CartItem implements Serializable {
    private int foodId;
    private String foodName;
    private BigDecimal unitPrice;
    private int quantity;
    private String addons;            // comma-separated names for display
    private BigDecimal addonsPrice;
    private List<Integer> selectedAddonIds = new ArrayList<>();  // FK references to addons table
    private String imageUrl;

    public CartItem() {}

    public CartItem(int foodId, String foodName, BigDecimal unitPrice, int quantity, String addons, BigDecimal addonsPrice, List<Integer> selectedAddonIds) {
        this.foodId = foodId;
        this.foodName = foodName;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.addons = addons;
        this.addonsPrice = addonsPrice;
        this.selectedAddonIds = selectedAddonIds != null ? selectedAddonIds : new ArrayList<>();
    }

    public CartItem(int foodId, String foodName, BigDecimal unitPrice, int quantity, String addons, BigDecimal addonsPrice, List<Integer> selectedAddonIds, String imageUrl) {
        this(foodId, foodName, unitPrice, quantity, addons, addonsPrice, selectedAddonIds);
        this.imageUrl = imageUrl;
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

    public List<Integer> getSelectedAddonIds() { return selectedAddonIds; }
    public void setSelectedAddonIds(List<Integer> selectedAddonIds) { this.selectedAddonIds = selectedAddonIds; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public BigDecimal getSubtotal() {
        BigDecimal base = unitPrice.add(addonsPrice == null ? BigDecimal.ZERO : addonsPrice);
        return base.multiply(new BigDecimal(quantity));
    }
}