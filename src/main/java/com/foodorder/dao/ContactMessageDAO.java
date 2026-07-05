package com.foodorder.dao;

import com.foodorder.model.ContactMessage;
import com.foodorder.util.DBConnection;

import java.sql.*;

public class ContactMessageDAO {

    public boolean save(ContactMessage msg) {
        String sql = "INSERT INTO contact_messages (user_id, name, email, subject, message) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, msg.getUserId());
            ps.setString(2, msg.getName());
            ps.setString(3, msg.getEmail());
            ps.setString(4, msg.getSubject());
            ps.setString(5, msg.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
