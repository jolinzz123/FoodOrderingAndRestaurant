package com.foodorder.servlet;

import com.foodorder.dao.AddonDAO;
import com.foodorder.model.Addon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/addon")
public class AdminAddonServlet extends HttpServlet {

    private final AddonDAO addonDAO = new AddonDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");
        int foodItemId = Integer.parseInt(req.getParameter("foodItemId"));

        if ("delete".equals(action) && idParam != null) {
            addonDAO.delete(Integer.parseInt(idParam));
        }

        resp.sendRedirect(req.getContextPath() + "/admin/food?action=edit&id=" + foodItemId);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int foodItemId = Integer.parseInt(req.getParameter("foodItemId"));
        String name = req.getParameter("name");

        if (name != null && !name.trim().isEmpty()) {
            BigDecimal extraPrice;
            try {
                String priceParam = req.getParameter("extraPrice");
                extraPrice = (priceParam == null || priceParam.trim().isEmpty())
                    ? BigDecimal.ZERO : new BigDecimal(priceParam.trim());
            } catch (NumberFormatException e) {
                extraPrice = BigDecimal.ZERO;
            }

            Addon a = new Addon();
            a.setFoodItemId(foodItemId);
            a.setName(name.trim());
            a.setExtraPrice(extraPrice);
            addonDAO.add(a);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/food?action=edit&id=" + foodItemId);
    }
}
