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

        if ("promote".equals(action) && idParam != null) {
            int targetId = Integer.parseInt(idParam);
            User currentUser = (User) req.getSession().getAttribute("user");
            boolean isSelf = currentUser != null && !currentUser.isAdmin() && currentUser.getId() == targetId;
            if (!isSelf) userDAO.promote(targetId);
        } else if ("demote".equals(action) && idParam != null) {
            int targetId = Integer.parseInt(idParam);
            User currentUser = (User) req.getSession().getAttribute("user");
            boolean isSelf = currentUser != null && currentUser.isAdmin() && currentUser.getId() == targetId;
            if (!isSelf) userDAO.demote(targetId);
        }

        String viewOrdersId = req.getParameter("viewOrdersId");
        String viewOrdersType = req.getParameter("viewOrdersType");
        if (viewOrdersId != null && !viewOrdersId.trim().isEmpty()) {
            int uid = Integer.parseInt(viewOrdersId.trim());
            User viewOrdersUser = "admin".equals(viewOrdersType) ? userDAO.findAdminById(uid) : userDAO.findCustomerById(uid);
            req.setAttribute("viewOrdersUser", viewOrdersUser);
            req.setAttribute("viewOrdersList", viewOrdersUser != null ? orderDAO.findByUser(uid) : new java.util.ArrayList<>());
        }

        boolean hasQuery = q != null && !q.trim().isEmpty();
        req.setAttribute("users", hasQuery ? userDAO.search(q.trim()) : userDAO.findAll());
        req.setAttribute("searchQuery", q);
        req.getRequestDispatcher("/admin/manage-users.jsp").forward(req, resp);
    }
}
