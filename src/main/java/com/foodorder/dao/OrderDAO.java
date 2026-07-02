package com.foodorder.dao;

import com.foodorder.model.CartItem;
import com.foodorder.model.Order;
import com.foodorder.model.OrderItem;
import com.foodorder.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * Persists a new order + its line items inside a single transaction.
     * Returns the generated order id, or -1 on failure.
     */
    public int placeOrder(int userId, List<CartItem> cartItems, BigDecimal total) {
        String orderSql   = "INSERT INTO orders (user_id, total_price, status) VALUES (?, ?, 'PENDING')";
        String itemSql    = "INSERT INTO order_items (order_id, food_id, quantity, subtotal) VALUES (?, ?, ?, ?)";
        String addonSql   = "INSERT INTO order_item_addons (order_item_id, addon_id) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int orderId;
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setBigDecimal(2, total);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) throw new SQLException("Failed to obtain order id");
                    orderId = keys.getInt(1);
                }
            }

            // Insert each order item and its selected add-ons
            try (PreparedStatement itemPs = conn.prepareStatement(itemSql, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement addonPs = conn.prepareStatement(addonSql)) {

                for (CartItem item : cartItems) {
                    itemPs.setInt(1, orderId);
                    itemPs.setInt(2, item.getFoodId());
                    itemPs.setInt(3, item.getQuantity());
                    itemPs.setBigDecimal(4, item.getSubtotal());
                    itemPs.executeUpdate();

                    int orderItemId;
                    try (ResultSet keys = itemPs.getGeneratedKeys()) {
                        if (!keys.next()) throw new SQLException("Failed to obtain order_item id");
                        orderItemId = keys.getInt(1);
                    }

                    // Link selected add-ons to this order item via junction table
                    List<Integer> addonIds = item.getSelectedAddonIds();
                    if (addonIds != null && !addonIds.isEmpty()) {
                        for (int addonId : addonIds) {
                            addonPs.setInt(1, orderItemId);
                            addonPs.setInt(2, addonId);
                            addonPs.addBatch();
                        }
                        addonPs.executeBatch();
                    }
                }
            }

            conn.commit();
            return orderId;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return -1;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public List<Order> findByUser(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) orders.add(mapOrderRow(rs));
            }
            for (Order o : orders) o.setItems(findItemsByOrderId(o.getId()));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.id ORDER BY o.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order o = mapOrderRow(rs);
                o.setUsername(rs.getString("username"));
                orders.add(o);
            }
            for (Order o : orders) o.setItems(findItemsByOrderId(o.getId()));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> search(String keyword) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.id " +
                     "WHERE u.username LIKE ? OR o.status LIKE ? OR CAST(o.id AS CHAR) LIKE ? " +
                     "ORDER BY o.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = mapOrderRow(rs);
                    o.setUsername(rs.getString("username"));
                    orders.add(o);
                }
            }
            for (Order o : orders) o.setItems(findItemsByOrderId(o.getId()));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /** Returns order counts grouped by status, e.g. {"COMPLETED": 12, "PENDING": 3, ...}. */
    public java.util.Map<String, Integer> countsByStatus() {
        java.util.Map<String, Integer> counts = new java.util.HashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM orders GROUP BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("status"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counts;
    }

    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private List<OrderItem> findItemsByOrderId(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        // JOIN through order_item_addons → addons to get comma-separated addon names
        String sql = "SELECT oi.id, oi.order_id, oi.food_id, f.name AS food_name, oi.quantity, oi.subtotal, " +
                     "GROUP_CONCAT(a.name ORDER BY a.id SEPARATOR ', ') AS addon_names " +
                     "FROM order_items oi " +
                     "JOIN food_items f ON oi.food_id = f.id " +
                     "LEFT JOIN order_item_addons oia ON oi.id = oia.order_item_id " +
                     "LEFT JOIN addons a ON oia.addon_id = a.id " +
                     "WHERE oi.order_id = ? " +
                     "GROUP BY oi.id, oi.order_id, oi.food_id, f.name, oi.quantity, oi.subtotal";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem oi = new OrderItem();
                    oi.setId(rs.getInt("id"));
                    oi.setOrderId(rs.getInt("order_id"));
                    oi.setFoodId(rs.getInt("food_id"));
                    oi.setFoodName(rs.getString("food_name"));
                    oi.setQuantity(rs.getInt("quantity"));
                    oi.setAddons(rs.getString("addon_names")); // from junction table
                    oi.setSubtotal(rs.getBigDecimal("subtotal"));
                    items.add(oi);
                }
            }
        }
        return items;
    }

    private Order mapOrderRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setTotalPrice(rs.getBigDecimal("total_price"));
        o.setStatus(rs.getString("status"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        return o;
    }
}
