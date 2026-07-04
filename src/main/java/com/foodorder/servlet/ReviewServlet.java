package com.foodorder.servlet;

import com.foodorder.dao.ReviewDAO;
import com.foodorder.model.Review;
import com.foodorder.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(req.getParameter("orderId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/menu");
            return;
        }

        // Multiple food items submitted in one form via foodIds[] array
        String[] foodIdParams = req.getParameterValues("foodIds");
        if (foodIdParams == null || foodIdParams.length == 0) {
            resp.sendRedirect(req.getContextPath() + "/review-success.jsp");
            return;
        }

        int saved = 0;
        for (String foodIdStr : foodIdParams) {
            int foodId;
            try { foodId = Integer.parseInt(foodIdStr); }
            catch (NumberFormatException e) { continue; }

            String ratingStr = req.getParameter("rating_" + foodId);
            int rating;
            try { rating = Integer.parseInt(ratingStr); }
            catch (NumberFormatException e) { continue; }

            // Skip items with no star selected
            if (rating < 1 || rating > 5) continue;

            // Skip if already reviewed
            if (reviewDAO.hasReviewed(user.getId(), foodId, orderId)) continue;

            String comment = req.getParameter("comment_" + foodId);
            if (comment != null) comment = comment.trim();

            Review review = new Review();
            review.setFoodId(foodId);
            review.setOrderId(orderId);
            review.setUserId(user.getId());
            review.setRating(rating);
            review.setComment(comment);
            reviewDAO.save(review);
            saved++;
        }

        resp.sendRedirect(req.getContextPath() + "/review-success.jsp" + (saved == 0 ? "?error=none" : ""));
    }
}
