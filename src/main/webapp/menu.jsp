<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.foodorder.model.FoodItem, com.foodorder.model.Category" %>
<%
    request.setAttribute("pageTitle", "Our Menu — FoodOrder");
    String ctx = request.getContextPath();
    List<FoodItem> foodItems = (List<FoodItem>) request.getAttribute("foodItems");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (foodItems == null) foodItems = java.util.Collections.emptyList();
    if (categories == null) categories = java.util.Collections.emptyList();
%>
<jsp:include page="header.jsp" />

<div class="container py-5">
  <div class="section-title">
    <h2>Our Menu</h2>
    <p>Fresh dishes across every category, made to order</p>
  </div>

  <div class="d-flex justify-content-center flex-wrap gap-2 mb-5">
    <a href="<%= ctx %>/menu"
       class="btn <%= (selectedCategory == null || selectedCategory.isEmpty()) ? "btn-brand" : "btn-outline-brand" %> btn-sm">All</a>
    <% for (Category cat : categories) {
         boolean active = String.valueOf(cat.getId()).equals(selectedCategory);
    %>
      <a href="<%= ctx %>/menu?category=<%= cat.getId() %>"
         class="btn <%= active ? "btn-brand" : "btn-outline-brand" %> btn-sm"><%= cat.getName() %></a>
    <% } %>
  </div>

  <div class="row g-4">
    <% if (foodItems.isEmpty()) { %>
      <div class="col-12 text-center text-muted py-5">
        <p>No food items found. Please make sure the database connection in <code>DBConnection.java</code> is configured, and that <code>schema.sql</code> has been imported.</p>
      </div>
    <% } else {
        for (FoodItem food : foodItems) {
    %>
      <div class="col-lg-3 col-md-4 col-sm-6">
        <div class="card-food">
          <a href="<%= ctx %>/food?id=<%= food.getId() %>">
            <img src="<%= ctx %>/<%= food.getImageUrl() %>" alt="<%= food.getName() %>">
          </a>
          <div class="card-body">
            <span class="badge-category mb-2 d-inline-block"><%= food.getCategoryName() %></span>
            <h6 class="mb-1">
              <a href="<%= ctx %>/food?id=<%= food.getId() %>" style="color:inherit;"><%= food.getName() %></a>
            </h6>
            <p class="text-muted small mb-2" style="min-height:38px;"><%= food.getDescription() %></p>
            <div class="d-flex justify-content-between align-items-center">
              <span class="price-tag">RM <%= String.format("%,.2f", food.getPrice()) %></span>
              <span class="badge-rating">★ <%= String.format("%.1f", food.getRating()) %></span>
            </div>
            <a href="<%= ctx %>/food?id=<%= food.getId() %>" class="btn btn-brand btn-sm w-100 mt-3">View & Order</a>
          </div>
        </div>
      </div>
    <%  }
       } %>
  </div>
</div>

<jsp:include page="footer.jsp" />
