<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.dao.FoodDAO, com.foodorder.model.FoodItem, java.util.List, java.util.ArrayList, java.util.Comparator" %>
<%

    request.setAttribute("pageTitle", "HotServe — Home");
    List<FoodItem> all = new FoodDAO().findAll();
    String ctx = request.getContextPath();

    // Popular Dishes — top rated
    List<FoodItem> byRating = new ArrayList<FoodItem>(all);
    byRating.sort(Comparator.comparingDouble(FoodItem::getRating).reversed());
    List<FoodItem> popularItems = byRating.size() > 6 ? byRating.subList(0, 6) : byRating;

    // Best Sellers — next tier by rating (swap for a real soldCount field if you add one to FoodItem)
    List<FoodItem> bestSellers = byRating.size() > 6
            ? byRating.subList(6, Math.min(byRating.size(), 12))
            : new ArrayList<FoodItem>();

    // New Arrivals — most recently added (highest id first; swap for createdAt if you add one)
    List<FoodItem> newest = new ArrayList<FoodItem>(all);
    newest.sort(Comparator.comparingInt(FoodItem::getId).reversed());
    List<FoodItem> newArrivals = newest.size() > 4 ? newest.subList(0, 4) : newest;
%>
<jsp:include page="header.jsp" />

<!-- HERO — square image with breathing room + overlay text -->
<section class="hp-hero-sq">
  <div class="container-fluid hp-hero-sq-pad">
    <div class="hp-hero-sq-frame">
      <img src="<%= ctx %>/images/hero-wine-cheese.jpg"
           alt="Featured spread"
           class="hp-hero-sq-img"
           onerror="this.src='https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=1200&q=85'">
      <div class="hp-hero-sq-overlay"></div>
      <div class="hp-hero-sq-content">
        <span class="hp-hero-sq-tag">🍽️ &nbsp;Fresh from our kitchen</span>
        <h1 class="hp-hero-sq-text">It's not just food, it's an experience worth coming back for — taste HotServe today.</h1>
      </div>
    </div>
  </div>
</section>

<!-- Three options row — compact square toggle tiles -->
<div class="container">
  <div class="hp-options-row">
    <a href="<%= ctx %>/menu" class="hp-option-tile">
      <span class="hp-option-tile-icon">📋</span>
      <span class="hp-option-tile-label">View Menu</span>
    </a>
    <div class="hp-option-tile" tabindex="0">
      <span class="hp-option-tile-icon">⚡</span>
      <span class="hp-option-tile-label">Fast Delivery</span>
    </div>
    <div class="hp-option-tile" tabindex="0">
      <span class="hp-option-tile-icon">💳</span>
      <span class="hp-option-tile-label">Easy Payment</span>
    </div>
  </div>
</div>

<!-- Popular Dishes -->
<div class="container py-5">
  <div class="d-flex align-items-end justify-content-between mb-4">
    <div>
      <p class="hp-section-pre">This Week's Picks</p>
      <h2 class="hp-section-title">Popular Dishes</h2>
    </div>
    <a href="<%= ctx %>/menu" class="hp-see-all">See All →</a>
  </div>

  <div class="hp-dishes-grid">
    <% if (popularItems.isEmpty()) { %>
      <p class="text-muted">No items found. <a href="<%= ctx %>/menu">Browse menu</a></p>
    <% } else {
        for (FoodItem item : popularItems) { %>
    <a href="<%= ctx %>/food?id=<%= item.getId() %>" class="hp-dish-card">
      <div class="hp-dish-img-wrap">
        <img src="<%= ctx %>/<%= item.getImageUrl() %>"
             alt="<%= item.getName() %>"
             onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=70'">
      </div>
      <div class="hp-dish-body">
        <span class="hp-dish-cat"><%= item.getCategoryName() %></span>
        <h6 class="hp-dish-name"><%= item.getName() %></h6>
        <div class="hp-dish-footer">
          <span class="hp-dish-price">RM <%= String.format("%,.2f", item.getPrice()) %></span>
          <span class="hp-dish-cart">🛒</span>
        </div>
      </div>
    </a>
    <% } } %>
  </div>
</div>

<!-- Best Sellers -->
<% if (!bestSellers.isEmpty()) { %>
<div class="hp-alt-section">
  <div class="container py-5">
    <div class="d-flex align-items-end justify-content-between mb-4">
      <div>
        <p class="hp-section-pre">Fan Favourites</p>
        <h2 class="hp-section-title">Best Sellers</h2>
      </div>
      <a href="<%= ctx %>/menu" class="hp-see-all">See All →</a>
    </div>
    <div class="hp-dishes-grid hp-dishes-grid--4">
      <% for (FoodItem item : bestSellers) { %>
      <a href="<%= ctx %>/food?id=<%= item.getId() %>" class="hp-dish-card">
        <div class="hp-dish-img-wrap">
          <img src="<%= ctx %>/<%= item.getImageUrl() %>"
               alt="<%= item.getName() %>"
               onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=70'">
        </div>
        <div class="hp-dish-body">
          <span class="hp-dish-cat"><%= item.getCategoryName() %></span>
          <h6 class="hp-dish-name"><%= item.getName() %></h6>
          <div class="hp-dish-footer">
            <span class="hp-dish-price">RM <%= String.format("%,.2f", item.getPrice()) %></span>
            <span class="hp-dish-cart">🛒</span>
          </div>
        </div>
      </a>
      <% } %>
    </div>
  </div>
</div>
<% } %>

<!-- New Arrivals -->
<% if (!newArrivals.isEmpty()) { %>
<div class="container py-5">
  <div class="d-flex align-items-end justify-content-between mb-4">
    <div>
      <p class="hp-section-pre">Just Added</p>
      <h2 class="hp-section-title">New Arrivals</h2>
    </div>
    <a href="<%= ctx %>/menu" class="hp-see-all">See All →</a>
  </div>
  <div class="hp-dishes-grid hp-dishes-grid--4">
    <% for (FoodItem item : newArrivals) { %>
    <a href="<%= ctx %>/food?id=<%= item.getId() %>" class="hp-dish-card">
      <div class="hp-dish-img-wrap">
        <span class="hp-dish-new-badge">NEW</span>
        <img src="<%= ctx %>/<%= item.getImageUrl() %>"
             alt="<%= item.getName() %>"
             onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=70'">
      </div>
      <div class="hp-dish-body">
        <span class="hp-dish-cat"><%= item.getCategoryName() %></span>
        <h6 class="hp-dish-name"><%= item.getName() %></h6>
        <div class="hp-dish-footer">
          <span class="hp-dish-price">RM <%= String.format("%,.2f", item.getPrice()) %></span>
          <span class="hp-dish-cart">🛒</span>
        </div>
      </div>
    </a>
    <% } %>
  </div>
</div>
<% } %>

<!-- About Us -->
<div class="hp-about-section">
  <div class="container">
    <div class="hp-about-inner">
      <div class="hp-about-text">
        <p class="hp-section-pre">About HotServe</p>
        <h2 class="hp-section-title mb-3">Made with care, served with pride</h2>
        <p class="hp-about-desc">HotServe started with one simple idea — good food shouldn't take long to reach you. Every dish is prepared fresh from locally sourced ingredients and delivered hot, straight from our kitchen to your table.</p>
        <a href="<%= ctx %>/about.jsp" class="hp-btn-primary">About Us</a>
      </div>
      <div class="hp-about-img-wrap">
        <img src="<%= ctx %>/images/about-feast.jpg"
             alt="Our kitchen"
             class="hp-about-img"
             onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=700&q=85'">
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
