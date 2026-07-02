package com.foodorder.servlet;

import com.foodorder.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        boolean hasQuery = q != null && !q.trim().isEmpty();
        req.setAttribute("orders", hasQuery ? orderDAO.search(q.trim()) : orderDAO.findAll());
        req.setAttribute("searchQuery", q);

        java.util.Map<String, Integer> statusCounts = orderDAO.countsByStatus();
        int totalOrders = 0;
        for (int c : statusCounts.values()) totalOrders += c;
        req.setAttribute("totalOrdersCount", totalOrders);
        req.setAttribute("completedOrdersCount", statusCounts.getOrDefault("COMPLETED", 0));
        req.setAttribute("pendingOrdersCount", statusCounts.getOrDefault("PENDING", 0));
        req.setAttribute("cancelledOrdersCount", statusCounts.getOrDefault("CANCELLED", 0));

        req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int orderId = Integer.parseInt(req.getParameter("orderId"));
        String status = req.getParameter("status");
        String q = req.getParameter("q");
        orderDAO.updateStatus(orderId, status);
        String redirectUrl = req.getContextPath() + "/admin/orders";
        if (q != null && !q.trim().isEmpty()) redirectUrl += "?q=" + java.net.URLEncoder.encode(q.trim(), "UTF-8");
        resp.sendRedirect(redirectUrl);
    }
}
