package com.foodorder.servlet;

import com.foodorder.dao.OrderDAO;
import com.foodorder.model.CartItem;
import com.foodorder.model.OrderItem;
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
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            req.setAttribute("error", "Your cart is empty.");
            req.getRequestDispatcher("cart.jsp").forward(req, resp);
            return;
        }

        String address = req.getParameter("address");
        String paymentMethod = req.getParameter("paymentMethod");

        if (address == null || address.trim().isEmpty()) {
            req.setAttribute("error", "Please enter a delivery address.");
            req.getRequestDispatcher("checkout.jsp").forward(req, resp);
            return;
        }

        List<CartItem> items = new ArrayList<>(cart.values());
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) total = total.add(item.getSubtotal());
        java.math.BigDecimal freeDeliveryThreshold = new java.math.BigDecimal("30.00");
        java.math.BigDecimal deliveryFee = total.compareTo(freeDeliveryThreshold) >= 0
                ? java.math.BigDecimal.ZERO : new java.math.BigDecimal("3.00");
        java.math.BigDecimal grandTotal = total.add(deliveryFee);

        int orderId = orderDAO.placeOrder(user.getId(), items, grandTotal, address.trim(), paymentMethod);

        if (orderId > 0) {
            cart.clear();
            List<OrderItem> orderItems = new ArrayList<>();
            for (CartItem ci : items) {
                OrderItem oi = new OrderItem();
                oi.setOrderId(orderId);
                oi.setFoodId(ci.getFoodId());
                oi.setFoodName(ci.getFoodName());
                oi.setQuantity(ci.getQuantity());
                oi.setAddons(ci.getAddons());
                oi.setSubtotal(ci.getSubtotal());
                orderItems.add(oi);
            }
            req.setAttribute("orderId", orderId);
            req.setAttribute("orderTotal", grandTotal);
            req.setAttribute("deliveryFee", deliveryFee);
            req.setAttribute("orderItems", orderItems);
            req.setAttribute("deliveryAddress", address.trim());
            req.setAttribute("paymentMethod", paymentMethod);
            req.getRequestDispatcher("order-confirmation.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Something went wrong while placing your order. Please try again.");
            req.getRequestDispatcher("checkout.jsp").forward(req, resp);
        }
    }
}
