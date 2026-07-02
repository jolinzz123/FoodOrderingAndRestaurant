package com.foodorder.servlet;

import com.foodorder.dao.CategoryDAO;
import com.foodorder.dao.FoodDAO;
import com.foodorder.model.FoodItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/food")
public class AdminFoodServlet extends HttpServlet {

    private final FoodDAO foodDAO = new FoodDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");
        String q = req.getParameter("q");
        boolean hasQuery = q != null && !q.trim().isEmpty();

        if ("delete".equals(action) && idParam != null) {
            foodDAO.delete(Integer.parseInt(idParam));
            String redirectUrl = req.getContextPath() + "/admin/food";
            if (hasQuery) redirectUrl += "?q=" + java.net.URLEncoder.encode(q.trim(), "UTF-8");
            resp.sendRedirect(redirectUrl);
            return;
        }

        if ("edit".equals(action) && idParam != null) {
            req.setAttribute("editItem", foodDAO.findById(Integer.parseInt(idParam)));
        }

        req.setAttribute("foodItems", hasQuery ? foodDAO.search(q.trim()) : foodDAO.findAll());
        req.setAttribute("categories", categoryDAO.findAll());
        req.setAttribute("searchQuery", q);
        req.getRequestDispatcher("/admin/manage-food.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        FoodItem f = new FoodItem();
        f.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
        f.setName(req.getParameter("name"));
        f.setDescription(req.getParameter("description"));
        f.setIngredients(req.getParameter("ingredients"));
        f.setNutritionalInfo(req.getParameter("nutritionalInfo"));
        f.setPrice(new BigDecimal(req.getParameter("price")));
        String imageUrl = req.getParameter("imageUrl");
        f.setImageUrl((imageUrl == null || imageUrl.trim().isEmpty()) ? "images/placeholder.jpg" : imageUrl.trim());
        f.setAvailable(req.getParameter("available") != null);

        if ("update".equals(action)) {
            f.setId(Integer.parseInt(req.getParameter("id")));
            foodDAO.update(f);
        } else {
            f.setRating(0.0);
            foodDAO.add(f);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/food");
    }
}
