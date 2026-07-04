package com.foodorder.dao;

import com.foodorder.model.Review;
import com.foodorder.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    /** All reviews for a food item, newest first. */
    public List<Review> findByFoodId(int foodId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.username FROM reviews r JOIN users u ON r.user_id = u.id " +
                     "WHERE r.food_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, foodId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Average rating for a food item (0 if none). */
    public double getAverageRating(int foodId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE food_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, foodId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getReviewCount(int foodId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE food_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, foodId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /** Count per star (1–5) for bar chart. */
    public int[] getRatingDistribution(int foodId) {
        int[] dist = new int[6]; // index 1–5
        String sql = "SELECT rating, COUNT(*) FROM reviews WHERE food_id = ? GROUP BY rating";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, foodId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) dist[rs.getInt(1)] = rs.getInt(2);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return dist;
    }

    /** Has this user already rated this food item from this order? */
    public boolean hasReviewed(int userId, int foodId, int orderId) {
        String sql = "SELECT id FROM reviews WHERE user_id=? AND food_id=? AND order_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, foodId); ps.setInt(3, orderId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean save(Review review) {
        String sql = "INSERT INTO reviews (food_id, order_id, user_id, rating, comment) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getFoodId());
            ps.setInt(2, review.getOrderId());
            ps.setInt(3, review.getUserId());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getComment());
            if (ps.executeUpdate() > 0) {
                // Update cached rating on food_items
                updateCachedRating(review.getFoodId(), conn);
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private void updateCachedRating(int foodId, Connection conn) {
        String sql = "UPDATE food_items SET rating = (SELECT AVG(rating) FROM reviews WHERE food_id=?) WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, foodId); ps.setInt(2, foodId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private Review mapRow(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setId(rs.getInt("id"));
        r.setFoodId(rs.getInt("food_id"));
        r.setOrderId(rs.getInt("order_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setUsername(rs.getString("username"));
        r.setRating(rs.getInt("rating"));
        r.setComment(rs.getString("comment"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}
