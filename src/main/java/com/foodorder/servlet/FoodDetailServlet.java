package com.foodorder.servlet;

import com.foodorder.dao.AddonDAO;
import com.foodorder.dao.FoodDAO;
import com.foodorder.model.FoodItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/food")
public class FoodDetailServlet extends HttpServlet {

    private final FoodDAO foodDAO = new FoodDAO();
    private final AddonDAO addonDAO = new AddonDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        FoodItem item = null;
        try {
            item = foodDAO.findById(Integer.parseInt(idParam));
        } catch (NumberFormatException | NullPointerException ignored) {}

        if (item == null) {
            resp.sendRedirect(req.getContextPath() + "/menu");
            return;
        }

        req.setAttribute("item", item);
        req.setAttribute("addons", addonDAO.findByFoodItemId(item.getId()));
        req.getRequestDispatcher("food-detail.jsp").forward(req, resp);
    }
}
