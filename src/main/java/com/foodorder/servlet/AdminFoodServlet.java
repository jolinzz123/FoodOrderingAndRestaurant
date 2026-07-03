package com.foodorder.servlet;

import com.foodorder.dao.AddonDAO;
import com.foodorder.dao.CategoryDAO;
import com.foodorder.dao.FoodDAO;
import com.foodorder.model.Category;
import com.foodorder.model.FoodItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/food")
public class AdminFoodServlet extends HttpServlet {

    private final FoodDAO foodDAO = new FoodDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final AddonDAO addonDAO = new AddonDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");
        String q = req.getParameter("q");
        String categoryIdParam = req.getParameter("categoryId");
        String sort = req.getParameter("sort");
        boolean hasQuery = q != null && !q.trim().isEmpty();
        boolean hasCategoryFilter = categoryIdParam != null && !categoryIdParam.trim().isEmpty();

        if ("delete".equals(action) && idParam != null) {
            foodDAO.delete(Integer.parseInt(idParam));
            StringBuilder redirectUrl = new StringBuilder(req.getContextPath()).append("/admin/food?");
            if (hasQuery) redirectUrl.append("q=").append(java.net.URLEncoder.encode(q.trim(), "UTF-8")).append("&");
            if (hasCategoryFilter) redirectUrl.append("categoryId=").append(categoryIdParam.trim()).append("&");
            if (sort != null && !sort.isEmpty()) redirectUrl.append("sort=").append(sort).append("&");
            resp.sendRedirect(redirectUrl.toString());
            return;
        }

        if ("edit".equals(action) && idParam != null) {
            int editId = Integer.parseInt(idParam);
            req.setAttribute("editItem", foodDAO.findById(editId));
            req.setAttribute("productAddons", addonDAO.findByFoodItemId(editId));
        }

        List<Category> categories = categoryDAO.findAll();
        String categoryFilterName = null;

        if (hasCategoryFilter) {
            int filterId = Integer.parseInt(categoryIdParam.trim());
            req.setAttribute("foodItems", foodDAO.findByCategory(filterId, sort));
            for (Category c : categories) {
                if (c.getId() == filterId) { categoryFilterName = c.getName(); break; }
            }
        } else if (hasQuery) {
            req.setAttribute("foodItems", foodDAO.search(q.trim(), sort));
        } else {
            req.setAttribute("foodItems", foodDAO.findAll(sort));
        }

        req.setAttribute("categories", categories);
        req.setAttribute("searchQuery", q);
        req.setAttribute("categoryFilterId", hasCategoryFilter ? categoryIdParam.trim() : null);
        req.setAttribute("categoryFilterName", categoryFilterName);
        req.setAttribute("sort", sort);
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
