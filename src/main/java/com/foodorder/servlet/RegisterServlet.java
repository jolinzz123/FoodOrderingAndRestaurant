package com.foodorder.servlet;

import com.foodorder.dao.UserDAO;
import com.foodorder.model.User;
import com.foodorder.util.PasswordUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[\\w.+-]+@[\\w-]+\\.[a-zA-Z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+\\-\\s]{7,20}$");

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = trim(req.getParameter("username"));
        String email = trim(req.getParameter("email"));
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String phone = trim(req.getParameter("phone"));

        String error = validate(username, email, password, confirmPassword, phone);

        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            RequestDispatcher rd = req.getRequestDispatcher("register.jsp");
            rd.forward(req, resp);
            return;
        }

        User user = new User(username, email, PasswordUtil.hash(password), phone, "CUSTOMER");
        boolean success = userDAO.register(user);

        if (success) {
            req.setAttribute("message", "Account created successfully. Please log in.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }

    private String validate(String username, String email, String password, String confirmPassword, String phone) {
        if (username == null || username.length() < 3) return "Username must be at least 3 characters.";
        if (email == null || !EMAIL_PATTERN.matcher(email).matches()) return "Please enter a valid email address.";
        if (password == null || password.length() < 6) return "Password must be at least 6 characters.";
        if (!password.equals(confirmPassword)) return "Passwords do not match.";
        if (phone == null || !PHONE_PATTERN.matcher(phone).matches()) return "Please enter a valid phone number.";
        if (userDAO.usernameOrEmailExists(username, email)) return "Username or email already in use.";
        return null;
    }

    private String trim(String s) { return s == null ? null : s.trim(); }
}
