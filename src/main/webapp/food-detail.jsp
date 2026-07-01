<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.FoodItem, com.foodorder.model.User, com.foodorder.model.Addon, java.util.List" %>
<%
    FoodItem item = (FoodItem) request.getAttribute("item");
    request.setAttribute("pageTitle", item.getName() + " — FoodOrder");
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
    User currentUser = (User) session.getAttribute("user");
    @SuppressWarnings("unchecked")
    List<Addon> addons = (List<Addon>) request.getAttribute("addons");
%>
<jsp:include page="header.jsp" />

<div class="container py-5">
  <div class="row g-5">
    <div class="col-md-6">
      <img src="<%= ctx %>/<%= item.getImageUrl() %>" alt="<%= item.getName() %>"
           class="img-fluid rounded-4 shadow-sm" style="width:100%; max-height:280px; object-fit:cover;"
           onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80'">
    </div>
    <div class="col-md-6">
      <span class="badge-category mb-2 d-inline-block"><%= item.getCategoryName() %></span>
      <h2><%= item.getName() %></h2>
      <p class="mb-2"><span class="badge-rating">★ <%= String.format("%.1f", item.getRating()) %></span></p>
      <p class="text-muted"><%= item.getDescription() %></p>

      <h6 class="mt-4">Ingredients</h6>
      <p class="text-muted"><%= item.getIngredients() %></p>

      <h6 class="mt-3">Nutritional Information</h6>
      <p class="text-muted"><%= item.getNutritionalInfo() %></p>

      <h3 class="price-tag mt-3">RM <%= String.format("%,.2f", item.getPrice()) %></h3>

      <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
      <% } %>

      <form action="<%= ctx %>/cart" method="post" id="addToCartForm" class="mt-3">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="foodId" value="<%= item.getId() %>">

        <div class="mb-3">
          <label for="quantity" class="form-label">Quantity</label>
          <input type="number" class="form-control" id="quantity" name="quantity" value="1" min="1" max="20" style="max-width:120px;" required>
        </div>

        <% if (addons != null && !addons.isEmpty()) { %>
        <div class="mb-3">
          <label class="form-label">Add-ons</label>
          <% for (Addon a : addons) { %>
          <div class="form-check">
            <input class="form-check-input" type="checkbox" name="addons"
                   value="<%= a.getId() %>" id="addon<%= a.getId() %>">
            <label class="form-check-label" for="addon<%= a.getId() %>">
              <%= a.getName() %>
              <% if (a.getExtraPrice() != null && a.getExtraPrice().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                <span class="text-muted">(+RM <%= String.format("%.2f", a.getExtraPrice()) %>)</span>
              <% } else { %>
                <span class="text-muted">(Free)</span>
              <% } %>
            </label>
          </div>
          <% } %>
        </div>
        <% } %>

        <% if (currentUser != null) { %>
          <button type="submit" class="btn btn-brand btn-lg w-100">Add to Cart</button>
        <% } else { %>
          <a href="<%= ctx %>/login.jsp" class="btn btn-brand btn-lg w-100">Log in to Order</a>
        <% } %>
      </form>
    </div>
  </div>

  <hr class="my-5">

  <div class="row">
    <div class="col-md-8 mx-auto">
      <h4 class="mb-3">Ratings & Reviews</h4>
      <div class="d-flex align-items-center mb-3">
        <span class="badge-rating fs-5 me-2">★ <%= String.format("%.1f", item.getRating()) %></span>
        <span class="text-muted">based on customer feedback</span>
      </div>
      <p class="text-muted">Reviews are aggregated from verified orders. Log in and place an order to leave your own review.</p>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
