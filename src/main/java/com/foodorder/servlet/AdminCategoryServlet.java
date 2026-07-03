package com.foodorder.servlet;

import com.foodorder.dao.CategoryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/category")
public class AdminCategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");
        String q = req.getParameter("q");
        boolean hasQuery = q != null && !q.trim().isEmpty();

        if ("delete".equals(action) && idParam != null) {
            categoryDAO.delete(Integer.parseInt(idParam));
        }

        if ("edit".equals(action) && idParam != null) {
            req.setAttribute("editItem", categoryDAO.findById(Integer.parseInt(idParam)));
        }

        req.setAttribute("categories", hasQuery ? categoryDAO.search(q.trim()) : categoryDAO.findAll());
        req.setAttribute("searchQuery", q);
        req.getRequestDispatcher("/admin/manage-category.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String name = req.getParameter("name");

        if (name != null && !name.trim().isEmpty()) {
            if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                categoryDAO.update(id, name.trim());
            } else {
                categoryDAO.add(name.trim());
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/category");
    }
}
