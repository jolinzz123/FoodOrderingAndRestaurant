<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.dao.FoodDAO, com.foodorder.model.FoodItem, java.util.List, java.util.Comparator" %>
<%
    request.setAttribute("pageTitle", "FoodOrder — Home");
    List<FoodItem> all = new FoodDAO().findAll();
    all.sort(Comparator.comparingDouble(FoodItem::getRating).reversed());
    List<FoodItem> popularItems = all.size() > 4 ? all.subList(0, 4) : all;
    String ctx = request.getContextPath();
%>
<jsp:include page="header.jsp" />

<section class="hero">
  <div class="container">
    <h1>Great Food, Delivered Fresh.</h1>
    <p>Browse our curated menu of appetizers, mains, and desserts — crafted by our partner restaurants.</p>
    <a href="<%= ctx %>/menu" class="btn btn-light btn-lg">View Menu</a>
  </div>
</section>

<div class="container py-5">

  <div class="section-title">
    <h2>Featured Restaurants</h2>
    <p>Our top-rated kitchen partners</p>
  </div>
  <div class="row g-4 mb-5">
    <div class="col-md-4">
      <div class="card-food">
        <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600&q=80" alt="The Green Table">
        <div class="card-body">
          <h5>The Green Table</h5>
          <p class="text-muted mb-1">Farm-to-table contemporary cuisine</p>
          <span class="badge-rating">★ 4.8</span>
        </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card-food">
        <img src="https://images.unsplash.com/photo-1559339352-11d035aa65de?w=600&q=80" alt="Maple & Smoke">
        <div class="card-body">
          <h5>Maple & Smoke Grill</h5>
          <p class="text-muted mb-1">Char-grilled steaks and seafood</p>
          <span class="badge-rating">★ 4.7</span>
        </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card-food">
        <img src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600&q=80" alt="Bella Pasta House">
        <div class="card-body">
          <h5>Bella Pasta House</h5>
          <p class="text-muted mb-1">Authentic Italian comfort food</p>
          <span class="badge-rating">★ 4.6</span>
        </div>
      </div>
    </div>
  </div>

  <div class="section-title">
    <h2>Popular Dishes</h2>
    <p>Customer favorites this week</p>
  </div>
  <div class="row g-4">
    <% if (popularItems.isEmpty()) { %>
      <div class="col-12 text-center text-muted">
        <p>Menu items will appear here once the database is connected. <a href="<%= ctx %>/menu">Browse full menu &rarr;</a></p>
      </div>
    <% } else {
        for (FoodItem item : popularItems) {
    %>
      <div class="col-md-3 col-sm-6">
        <a href="<%= ctx %>/food?id=<%= item.getId() %>" style="text-decoration:none;">
          <div class="card-food">
            <img src="<%= ctx %>/<%= item.getImageUrl() %>" alt="<%= item.getName() %>">
            <div class="card-body">
              <h6 class="mb-1"><%= item.getName() %></h6>
              <span class="price-tag">RM <%= String.format("%,.2f", item.getPrice()) %></span>
            </div>
          </div>
        </a>
      </div>
    <%  }
       } %>
  </div>

  <div class="text-center mt-5">
    <a href="<%= ctx %>/menu" class="btn btn-brand btn-lg">Explore Full Menu</a>
  </div>
</div>

<jsp:include page="footer.jsp" />
