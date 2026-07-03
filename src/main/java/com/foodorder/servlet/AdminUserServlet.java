package com.foodorder.servlet;

import com.foodorder.dao.OrderDAO;
import com.foodorder.dao.UserDAO;
import com.foodorder.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");
        String q = req.getParameter("q");

        if (("promote".equals(action) || "demote".equals(action)) && idParam != null) {
            User currentUser = (User) req.getSession().getAttribute("user");
            int targetId = Integer.parseInt(idParam);
            if (currentUser == null || currentUser.getId() != targetId) {
                userDAO.updateRole(targetId, "promote".equals(action) ? "ADMIN" : "CUSTOMER");
            }
        }

        String viewOrdersId = req.getParameter("viewOrdersId");
        if (viewOrdersId != null && !viewOrdersId.trim().isEmpty()) {
            int uid = Integer.parseInt(viewOrdersId.trim());
            req.setAttribute("viewOrdersUser", userDAO.findById(uid));
            req.setAttribute("viewOrdersList", orderDAO.findByUser(uid));
        }

        boolean hasQuery = q != null && !q.trim().isEmpty();
        req.setAttribute("users", hasQuery ? userDAO.search(q.trim()) : userDAO.findAll());
        req.setAttribute("searchQuery", q);
        req.getRequestDispatcher("/admin/manage-users.jsp").forward(req, resp);
    }
}
