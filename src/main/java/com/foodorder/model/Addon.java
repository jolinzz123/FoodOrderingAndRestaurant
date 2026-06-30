package com.foodorder.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class Addon implements Serializable {
    private int id;
    private int foodItemId;
    private String name;
    private BigDecimal extraPrice;

    public Addon() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getFoodItemId() { return foodItemId; }
    public void setFoodItemId(int foodItemId) { this.foodItemId = foodItemId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public BigDecimal getExtraPrice() { return extraPrice; }
    public void setExtraPrice(BigDecimal extraPrice) { this.extraPrice = extraPrice; }
}
