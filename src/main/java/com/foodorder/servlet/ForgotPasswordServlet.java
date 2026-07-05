package com.foodorder.servlet;

import com.foodorder.dao.UserDAO;
import com.foodorder.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // when request, directly use the find password page built before
        req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // 1. basic null and length of password checking (Consider RegisterServlet）
        if (email == null || email.trim().isEmpty() || password == null || confirmPassword == null) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
            return;
        }

        // 2. check whether the email exist(Use usernameOrEmailExists method in the RegisterServlet，pass the null user name）
        // the method only check whether it exist, if not, take error
        if (!userDAO.usernameOrEmailExists("", email.trim())) {
            req.setAttribute("error", "Email address is not registered in our system.");
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
            return;
        }

        // 3. hash and renew password
        String hashedNewPassword = PasswordUtil.hash(password);
        boolean success = userDAO.updatePasswordByEmail(email.trim(), hashedNewPassword);

        if (success) {
            // if success, take the message into login.jsp and inform user
            req.setAttribute("message", "Password reset successfully. Please log in with your new password.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Failed to reset password. Please try again.");
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
        }
    }
}