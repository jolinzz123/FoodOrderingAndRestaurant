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
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new LinkedHashMap<>();
        req.setAttribute("cartItems", cart.values());
        req.setAttribute("cartTotal", calculateTotal(cart));
        req.getRequestDispatcher("cart.jsp").forward(req, resp);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            int foodId = Integer.parseInt(req.getParameter("foodId"));
            int quantity = parseQuantity(req.getParameter("quantity"));
            String editKey = req.getParameter("editKey");
            if (editKey != null && !editKey.isEmpty()) cart.remove(editKey);
            String[] addonIdParams = req.getParameterValues("addons");

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
                String key = CartItem.buildKey(foodId, selectedAddonIds);
                CartItem existing = cart.get(key);
                if (existing != null) {
                    existing.setQuantity(existing.getQuantity() + quantity);
                } else {
                    cart.put(key, new CartItem(foodId, food.getName(), food.getPrice(), quantity,
                            addonsLabel.toString(), addonsPrice, selectedAddonIds, food.getImageUrl()));
                }
            }
        } else if ("update".equals(action)) {
            String cartKey = req.getParameter("cartKey");
            int quantity = parseQuantityAllowZero(req.getParameter("quantity"));
            if (cartKey != null) {
                CartItem item = cart.get(cartKey);
                if (item != null) {
                    if (quantity <= 0) cart.remove(cartKey);
                    else item.setQuantity(quantity);
                }
            }
        } else if ("remove".equals(action)) {
            String cartKey = req.getParameter("cartKey");
            if (cartKey != null) cart.remove(cartKey);
        } else if ("clear".equals(action)) {
            cart.clear();
        }

        String returnTo = req.getParameter("returnTo");
        if (returnTo != null && returnTo.startsWith("/")) {
            resp.sendRedirect(req.getContextPath() + returnTo);
        } else {
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    private int parseQuantity(String s) {
        try {
            int q = Integer.parseInt(s);
            return Math.max(q, 1);
        } catch (NumberFormatException | NullPointerException e) {
            return 1;
        }
    }

    private int parseQuantityAllowZero(String s) {
        try {
            return Math.max(Integer.parseInt(s), 0);
        } catch (NumberFormatException | NullPointerException e) {
            return 1;
        }
    }

    private BigDecimal calculateTotal(Map<String, CartItem> cart) {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart.values()) total = total.add(item.getSubtotal());
        return total;
    }
}