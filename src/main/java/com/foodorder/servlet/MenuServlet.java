package com.foodorder.servlet;

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
import java.util.List;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private final FoodDAO foodDAO = new FoodDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String categoryParam = req.getParameter("category");
        List<FoodItem> foodItems;

        if (categoryParam != null && !categoryParam.isEmpty()) {
            try {
                foodItems = foodDAO.findByCategory(Integer.parseInt(categoryParam));
            } catch (NumberFormatException e) {
                foodItems = foodDAO.findAll();
            }
        } else {
            foodItems = foodDAO.findAll();
        }

        req.setAttribute("foodItems", foodItems);
        req.setAttribute("categories", categoryDAO.findAll());
        req.setAttribute("selectedCategory", categoryParam);
        req.getRequestDispatcher("menu.jsp").forward(req, resp);
    }
}
