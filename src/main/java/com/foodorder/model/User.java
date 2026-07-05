package com.foodorder.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {
    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private String phone;
    // Set explicitly by whichever DAO method loaded this row — true if it came
    // from the admins table, false if it came from the customers table.
    private boolean admin;
    private Timestamp createdAt;

    public User() {}

    public User(String username, String email, String passwordHash, String phone) {
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isAdmin() { return admin; }
    public void setAdmin(boolean admin) { this.admin = admin; }
}
