package com.foodorder.servlet;

import com.foodorder.dao.AddonDAO;
import com.foodorder.dao.FoodDAO;
import com.foodorder.dao.ReviewDAO;
import com.foodorder.model.FoodItem;
import com.foodorder.model.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/food")
public class FoodDetailServlet extends HttpServlet {

    private final FoodDAO foodDAO = new FoodDAO();
    private final AddonDAO addonDAO = new AddonDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

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

        // Reviews data
        List<Review> reviews = reviewDAO.findByFoodId(item.getId());
        double avgRating = reviewDAO.getAverageRating(item.getId());
        int reviewCount = reviewDAO.getReviewCount(item.getId());
        int[] ratingDist = reviewDAO.getRatingDistribution(item.getId());

        // "You may also like" — up to 3 items from same category, excluding this item
        final int thisId = item.getId();
        List<FoodItem> related = foodDAO.findByCategory(item.getCategoryId()).stream()
                .filter(f -> f.getId() != thisId)
                .limit(3)
                .collect(Collectors.toList());

        req.setAttribute("item", item);
        req.setAttribute("addons", addonDAO.findByFoodItemId(item.getId()));
        req.setAttribute("reviews", reviews);
        req.setAttribute("avgRating", avgRating);
        req.setAttribute("reviewCount", reviewCount);
        req.setAttribute("ratingDist", ratingDist);
        req.setAttribute("related", related);
        req.getRequestDispatcher("food-detail.jsp").forward(req, resp);
    }
}
