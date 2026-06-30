package com.foodorder.servlet;

import com.foodorder.dao.AddonDAO;
import com.foodorder.dao.FoodDAO;
import com.foodorder.model.Addon;
import com.foodorder.model.CartItem;
import com.foodorder.model.FoodItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final FoodDAO foodDAO = new FoodDAO();
    private final AddonDAO addonDAO = new AddonDAO();

    @Override
    @SuppressWarnings("unchecked")
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new LinkedHashMap<>();
        req.setAttribute("cartItems", cart.values());
        req.setAttribute("cartTotal", calculateTotal(cart));
        req.getRequestDispatcher("cart.jsp").forward(req, resp);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            int foodId = Integer.parseInt(req.getParameter("foodId"));
            int quantity = parseQuantity(req.getParameter("quantity"));
            String[] addonIdParams = req.getParameterValues("addons");

            // Resolve addon IDs → names + prices from the addons table
            BigDecimal addonsPrice = BigDecimal.ZERO;
            StringBuilder addonsLabel = new StringBuilder();
            List<Integer> selectedAddonIds = new ArrayList<>();
            if (addonIdParams != null) {
                for (String idStr : addonIdParams) {
                    try {
                        int addonId = Integer.parseInt(idStr);
                        Addon addon = addonDAO.findById(addonId);
                        if (addon != null) {
                            selectedAddonIds.add(addonId);
                            if (addonsLabel.length() > 0) addonsLabel.append(", ");
                            addonsLabel.append(addon.getName());
                            addonsPrice = addonsPrice.add(addon.getExtraPrice());
                        }
                    } catch (NumberFormatException ignored) {}
                }
            }

            FoodItem food = foodDAO.findById(foodId);
            if (food != null) {
                CartItem existing = cart.get(foodId);
                if (existing != null) {
                    existing.setQuantity(existing.getQuantity() + quantity);
                } else {
                    cart.put(foodId, new CartItem(foodId, food.getName(), food.getPrice(), quantity,
                            addonsLabel.toString(), addonsPrice, selectedAddonIds, food.getImageUrl()));
                }
            }
        } else if ("update".equals(action)) {
            int foodId = Integer.parseInt(req.getParameter("foodId"));
            int quantity = parseQuantity(req.getParameter("quantity"));
            CartItem item = cart.get(foodId);
            if (item != null) {
                if (quantity <= 0) cart.remove(foodId);
                else item.setQuantity(quantity);
            }
        } else if ("remove".equals(action)) {
            int foodId = Integer.parseInt(req.getParameter("foodId"));
            cart.remove(foodId);
        } else if ("clear".equals(action)) {
            cart.clear();
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private int parseQuantity(String s) {
        try {
            int q = Integer.parseInt(s);
            return Math.max(q, 1);
        } catch (NumberFormatException | NullPointerException e) {
            return 1;
        }
    }

    private BigDecimal calculateTotal(Map<Integer, CartItem> cart) {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart.values()) total = total.add(item.getSubtotal());
        return total;
    }
}