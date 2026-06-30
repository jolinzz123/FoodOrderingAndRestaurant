package com.foodorder.servlet;

import com.foodorder.dao.UserDAO;
import com.foodorder.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    /**
     * Hashes a plain-text password using SHA-256 and returns the hex string.
     * The same algorithm used when the account was created, so the hashes match.
     */
    private String hashPassword(String plainPassword) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(plainPassword.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String rawPassword = req.getParameter("password");

        if (username == null || username.trim().isEmpty() || rawPassword == null || rawPassword.isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        // Fetch user by username, then compare password_hash (never store/compare plain text)
        User user = userDAO.findByUsername(username.trim());
        String hashedInput = hashPassword(rawPassword);

        if (user == null || !hashedInput.equals(user.getPasswordHash())) {
            req.setAttribute("error", "Invalid username or password.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(30 * 60);

        if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
        } else {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }
}
