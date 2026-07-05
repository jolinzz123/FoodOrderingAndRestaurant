package com.foodorder.dao;

import com.foodorder.model.User;
import com.foodorder.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /** All customers and admins together, newest first — for the admin "All Users" list. */
    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        list.addAll(findAllIn("customers", false));
        list.addAll(findAllIn("admins", true));
        list.sort((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()));
        return list;
    }

    public List<User> search(String keyword) {
        List<User> list = new ArrayList<>();
        list.addAll(searchIn("customers", false, keyword));
        list.addAll(searchIn("admins", true, keyword));
        list.sort((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()));
        return list;
    }

    private List<User> findAllIn(String table, boolean isAdmin) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM " + table + " ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs, isAdmin));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<User> searchIn(String table, boolean isAdmin, String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM " + table + " WHERE username LIKE ? OR email LIKE ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs, isAdmin));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Promotes a customer to admin by moving their row into the admins table.
     * Fails (returns false) if they have orders/reviews/contact messages, since
     * those tables reference customers only.
     */
    public boolean promote(int customerId) {
        return moveRow("customers", "admins", customerId);
    }

    /** Demotes an admin back to a regular customer. */
    public boolean demote(int adminId) {
        return moveRow("admins", "customers", adminId);
    }

    private boolean moveRow(String fromTable, String toTable, int id) {
        String insertSql = "INSERT INTO " + toTable + " (username, email, password_hash, phone, created_at) " +
                            "SELECT username, email, password_hash, phone, created_at FROM " + fromTable + " WHERE id = ?";
        String deleteSql = "DELETE FROM " + fromTable + " WHERE id = ?";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setInt(1, id);
                    if (insertPs.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }
                try (PreparedStatement deletePs = conn.prepareStatement(deleteSql)) {
                    deletePs.setInt(1, id);
                    deletePs.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean register(User user) {
        String sql = "INSERT INTO customers (username, email, password_hash, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean usernameOrEmailExists(String username, String email) {
        return existsIn("customers", username, email) || existsIn("admins", username, email);
    }

    private boolean existsIn(String table, String username, String email) {
        String sql = "SELECT id FROM " + table + " WHERE username = ? OR email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** A username is unique across both tables, so try customers first, then admins. */
    public User findByUsername(String username) {
        User customer = findByUsernameIn("customers", false, username);
        return customer != null ? customer : findByUsernameIn("admins", true, username);
    }

    private User findByUsernameIn(String table, boolean isAdmin, String username) {
        String sql = "SELECT * FROM " + table + " WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs, isAdmin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findCustomerById(int id) {
        return findByIdIn("customers", false, id);
    }

    public User findAdminById(int id) {
        return findByIdIn("admins", true, id);
    }

    private User findByIdIn(String table, boolean isAdmin, int id) {
        String sql = "SELECT * FROM " + table + " WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs, isAdmin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private User mapRow(ResultSet rs, boolean isAdmin) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setPhone(rs.getString("phone"));
        u.setAdmin(isAdmin);
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }

    public boolean updatePasswordByEmail(String email, String newHashedPassword) {
        return updatePasswordIn("customers", email, newHashedPassword)
            || updatePasswordIn("admins", email, newHashedPassword);
    }

    private boolean updatePasswordIn(String table, String email, String newHashedPassword) {
        String sql = "UPDATE " + table + " SET password_hash = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHashedPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
