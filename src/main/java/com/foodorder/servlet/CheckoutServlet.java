package com.foodorder.servlet;

import com.foodorder.dao.OrderDAO;
import com.foodorder.model.CartItem;
import com.foodorder.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Show checkout confirmation form using current cart contents (AuthFilter already guarantees login)
        req.getRequestDispatcher("checkout.jsp").forward(req, resp);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            req.setAttribute("error", "Your cart is empty.");
            req.getRequestDispatcher("cart.jsp").forward(req, resp);
            return;
        }

        List<CartItem> items = new ArrayList<>(cart.values());
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) total = total.add(item.getSubtotal());

        int orderId = orderDAO.placeOrder(user.getId(), items, total);

        if (orderId > 0) {
            cart.clear();
            req.setAttribute("orderId", orderId);
            req.setAttribute("orderTotal", total);
            req.setAttribute("orderItems", items);
            req.getRequestDispatcher("order-confirmation.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Something went wrong while placing your order. Please try again.");
            req.getRequestDispatcher("checkout.jsp").forward(req, resp);
        }
    }
}
