<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList, com.foodorder.model.FoodItem, com.foodorder.model.Category" %>
<%
    request.setAttribute("pageTitle", "Our Menu — FoodOrder");
    String ctx = request.getContextPath();
    List<FoodItem> foodItems = (List<FoodItem>) request.getAttribute("foodItems");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (foodItems == null) foodItems = java.util.Collections.emptyList();
    if (categories == null) categories = java.util.Collections.emptyList();

    // Group items by category for section headers
    java.util.LinkedHashMap<String, List<FoodItem>> grouped = new java.util.LinkedHashMap<>();
    for (FoodItem fi : foodItems) {
        String cat = fi.getCategoryName() != null ? fi.getCategoryName() : "Other";
        grouped.computeIfAbsent(cat, k -> new ArrayList<>()).add(fi);
    }
%>
<jsp:include page="header.jsp" />

<div class="menu-hero">
  <h1>Our Menu</h1>
  <p>Fresh dishes across every category, made to order</p>
</div>

<div class="cat-bar">
  <div class="cat-bar-inner">
    <a href="<%= ctx %>/menu"
       class="cat-pill <%= (selectedCategory == null || selectedCategory.isEmpty()) ? "active" : "" %>">All</a>
    <% for (Category cat : categories) {
         boolean active = String.valueOf(cat.getId()).equals(selectedCategory);
    %>
      <a href="<%= ctx %>/menu?category=<%= cat.getId() %>"
         class="cat-pill <%= active ? "active" : "" %>"><%= cat.getName() %></a>
    <% } %>
  </div>
</div>

<div class="container py-4">

  <% if (foodItems.isEmpty()) { %>
    <div class="text-center text-muted py-5">
      <p>No food items found. Please make sure the database connection in <code>DBConnection.java</code> is configured, and that <code>setup.sql</code> has been imported.</p>
    </div>
  <% } else {
       for (java.util.Map.Entry<String, List<FoodItem>> entry : grouped.entrySet()) { %>

    <div class="section-label"><%= entry.getKey() %></div>

    <div class="row g-4 mb-2">
      <% for (FoodItem food : entry.getValue()) {
           double r = food.getRating();
           StringBuilder stars = new StringBuilder();
           for (int s = 1; s <= 5; s++) {
               if (s <= (int) r) stars.append("\u2605");
               else if (s - r < 1) stars.append("\u2729");
               else stars.append("\u2606");
           }
      %>
      <div class="col-lg-3 col-md-4 col-sm-6">
        <div class="card-food h-100 d-flex flex-column">
          <a href="<%= ctx %>/food?id=<%= food.getId() %>">
            <img src="<%= ctx %>/<%= food.getImageUrl() %>" alt="<%= food.getName() %>">
          </a>
          <div class="card-body d-flex flex-column flex-grow-1">
            <span class="badge-category mb-2 d-inline-block" style="width:fit-content;"><%= food.getCategoryName() %></span>

            <h6 class="mb-1">
              <a href="<%= ctx %>/food?id=<%= food.getId() %>" style="color:inherit;"><%= food.getName() %></a>
            </h6>
            <p class="text-muted small mb-2" style="min-height:38px;"><%= food.getDescription() %></p>

            <div class="star-row">
              <span class="stars"><%= stars %></span>
              <span class="rating-num"><%= String.format("%.1f", r) %> / 5.0</span>
            </div>

            <% if (food.getNutritionalInfo() != null && !food.getNutritionalInfo().isEmpty()) { %>
            <div class="nutr-box">
              <strong>Nutrition:</strong> <%= food.getNutritionalInfo() %>
            </div>
            <% } %>

            <% if (food.getIngredients() != null && !food.getIngredients().isEmpty()) { %>
            <button type="button" class="ingr-btn" onclick="toggleIngr(this)">+ Show ingredients</button>
            <div class="ingr-panel">
              <strong>Ingredients:</strong> <%= food.getIngredients() %>
            </div>
            <% } %>

            <div class="price-cta mt-auto">
              <span class="price-tag">RM <%= String.format("%,.2f", food.getPrice()) %></span>
              <a href="<%= ctx %>/food?id=<%= food.getId() %>" class="btn-add">View &amp; Order</a>
            </div>
          </div>
        </div>
      </div>
      <% } %>
    </div>

  <% } } %>
</div>

<script>
  function toggleIngr(btn) {
    var panel = btn.nextElementSibling;
    panel.classList.toggle('open');
    btn.textContent = panel.classList.contains('open')
      ? '\u2212 Hide ingredients' : '+ Show ingredients';
  }
</script>

<jsp:include page="footer.jsp" />
