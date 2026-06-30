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

        if ("delete".equals(action) && idParam != null) {
            categoryDAO.delete(Integer.parseInt(idParam));
        }

        req.setAttribute("categories", categoryDAO.findAll());
        req.getRequestDispatcher("/admin/manage-category.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        if (name != null && !name.trim().isEmpty()) {
            categoryDAO.add(name.trim());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/category");
    }
}
