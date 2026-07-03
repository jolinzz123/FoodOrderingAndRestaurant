package com.foodorder.dao;

import com.foodorder.model.FoodItem;
import com.foodorder.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FoodDAO {

    private static final String BASE_SELECT =
        "SELECT f.*, c.name AS category_name FROM food_items f " +
        "LEFT JOIN categories c ON f.category_id = c.id ";

    public List<FoodItem> findAll() {
        return findAll(null);
    }

    public List<FoodItem> findAll(String sort) {
        List<FoodItem> list = new ArrayList<>();
        String sql = BASE_SELECT + orderClause(sort, "ORDER BY c.id, f.name");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<FoodItem> search(String keyword) {
        return search(keyword, null);
    }

    public List<FoodItem> search(String keyword, String sort) {
        List<FoodItem> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE f.name LIKE ? OR c.name LIKE ? " + orderClause(sort, "ORDER BY c.id, f.name");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<FoodItem> findByCategory(int categoryId) {
        return findByCategory(categoryId, null);
    }

    public List<FoodItem> findByCategory(int categoryId, String sort) {
        List<FoodItem> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE f.category_id = ? " + orderClause(sort, "ORDER BY f.name");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Whitelists the "sort" query param to a safe ORDER BY clause (avoids building SQL from arbitrary input). */
    private String orderClause(String sort, String defaultClause) {
        if ("price_asc".equals(sort)) return "ORDER BY f.price ASC";
        if ("price_desc".equals(sort)) return "ORDER BY f.price DESC";
        return defaultClause;
    }

    public FoodItem findById(int id) {
        String sql = BASE_SELECT + "WHERE f.id = ?";
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

    public boolean add(FoodItem f) {
        String sql = "INSERT INTO food_items (category_id, name, description, ingredients, nutritional_info, price, image_url, rating, is_available) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, f.getCategoryId());
            ps.setString(2, f.getName());
            ps.setString(3, f.getDescription());
            ps.setString(4, f.getIngredients());
            ps.setString(5, f.getNutritionalInfo());
            ps.setBigDecimal(6, f.getPrice());
            ps.setString(7, f.getImageUrl());
            ps.setDouble(8, f.getRating());
            ps.setBoolean(9, f.isAvailable());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(FoodItem f) {
        String sql = "UPDATE food_items SET category_id=?, name=?, description=?, ingredients=?, nutritional_info=?, " +
                     "price=?, image_url=?, is_available=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, f.getCategoryId());
            ps.setString(2, f.getName());
            ps.setString(3, f.getDescription());
            ps.setString(4, f.getIngredients());
            ps.setString(5, f.getNutritionalInfo());
            ps.setBigDecimal(6, f.getPrice());
            ps.setString(7, f.getImageUrl());
            ps.setBoolean(8, f.isAvailable());
            ps.setInt(9, f.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM food_items WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private FoodItem mapRow(ResultSet rs) throws SQLException {
        FoodItem f = new FoodItem();
        f.setId(rs.getInt("id"));
        f.setCategoryId(rs.getInt("category_id"));
        f.setCategoryName(rs.getString("category_name"));
        f.setName(rs.getString("name"));
        f.setDescription(rs.getString("description"));
        f.setIngredients(rs.getString("ingredients"));
        f.setNutritionalInfo(rs.getString("nutritional_info"));
        f.setPrice(rs.getBigDecimal("price"));
        f.setImageUrl(rs.getString("image_url"));
        f.setRating(rs.getDouble("rating"));
        f.setAvailable(rs.getBoolean("is_available"));
        return f;
    }
}
