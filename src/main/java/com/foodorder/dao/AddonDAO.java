package com.foodorder.dao;

import com.foodorder.model.Addon;
import com.foodorder.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddonDAO {

    /** All add-ons available for a specific food item. */
    public List<Addon> findByFoodItemId(int foodItemId) {
        List<Addon> list = new ArrayList<>();
        String sql = "SELECT * FROM addons WHERE food_item_id = ? ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, foodItemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Single add-on by ID (used in CartServlet to resolve price/name from form). */
    public Addon findById(int id) {
        String sql = "SELECT * FROM addons WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Addon mapRow(ResultSet rs) throws SQLException {
        Addon a = new Addon();
        a.setId(rs.getInt("id"));
        a.setFoodItemId(rs.getInt("food_item_id"));
        a.setName(rs.getString("name"));
        a.setExtraPrice(rs.getBigDecimal("extra_price"));
        return a;
    }
}
