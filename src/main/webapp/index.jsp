<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.dao.FoodDAO, com.foodorder.model.FoodItem, java.util.List, java.util.Comparator" %>
<%
    request.setAttribute("pageTitle", "HotServe — Home");
    List<FoodItem> all = new FoodDAO().findAll();
    all.sort(Comparator.comparingDouble(FoodItem::getRating).reversed());
    List<FoodItem> popularItems = all.size() > 6 ? all.subList(0, 6) : all;
    String ctx = request.getContextPath();
    FoodItem heroFood = all.isEmpty() ? null : all.get(0);
%>
<jsp:include page="header.jsp" />


<!-- HERO — 2-column split -->
<section class="hp-hero">
  <div class="container">
    <div class="hp-hero-inner">

      <!-- Left text -->
      <div class="hp-hero-left">
        <span class="hp-hero-tag">🍽️ &nbsp;Fresh from our kitchen</span>
        <h1 class="hp-hero-heading">
          It's not just<br>
          <span style="font-style:italic;">Food,</span> It's an<br>
          <span class="hp-hero-highlight">Experience.</span>
        </h1>
        <p class="hp-hero-sub">Handcrafted dishes made to order — straight from our kitchen to your table every single day.</p>
        <div class="hp-hero-actions">
          <a href="<%= ctx %>/menu" class="hp-btn-primary">View Menu</a>
          <a href="<%= ctx %>/about.jsp" class="hp-btn-outline">About Us</a>
        </div>
        <!-- Reviews row -->
        <div class="hp-reviews">
          <div class="hp-avatars">
            <img src="https://i.pravatar.cc/32?img=11" alt="reviewer">
            <img src="https://i.pravatar.cc/32?img=22" alt="reviewer">
            <img src="https://i.pravatar.cc/32?img=33" alt="reviewer">
            <span class="hp-avatar-count">45+</span>
          </div>
          <div>
            <div class="hp-stars">★★★★★</div>
            <div class="hp-reviews-lbl">Happy customers</div>
          </div>
        </div>
      </div>

      <!-- Right image -->
      <div class="hp-hero-right">
        <div class="hp-hero-img-ring">
          <img src="https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=600&q=85"
               alt="Featured dish"
               class="hp-hero-img"
               onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=85'">
        </div>
        <!-- floating ingredient bubbles -->
        <div class="hp-float hp-float-1">🌶️</div>
        <div class="hp-float hp-float-3">🧄</div>
        <!-- stats pill -->
        <div class="hp-stat-pill">
          <span class="hp-stat-pill-num"><%= all.size() %>+</span>
          <span class="hp-stat-pill-lbl">Menu Items</span>
        </div>
      </div>

    </div>
  </div>

  <!-- wave bottom -->
  <div class="hp-wave">
    <svg viewBox="0 0 1440 80" preserveAspectRatio="none"><path d="M0,40 C360,80 1080,0 1440,40 L1440,80 L0,80 Z" fill="#FFFFFF"/></svg>
  </div>
</section>

<!-- Stats bar -->
<div class="hp-stats-bar">
  <div class="container">
    <div class="hp-stats-row">
      <div class="hp-stat-box">
        <span class="hp-stat-n"><%= all.size() %>+</span>
        <span class="hp-stat-l">Dishes</span>
      </div>
      <div class="hp-stat-divider"></div>
      <div class="hp-stat-box">
        <span class="hp-stat-n">7</span>
        <span class="hp-stat-l">Categories</span>
      </div>
      <div class="hp-stat-divider"></div>
      <div class="hp-stat-box">
      	<span class="hp-stat-n">FREE</span>
        <span class="hp-stat-l">Delivery</span>
      </div>
      <div class="hp-stat-divider"></div>
      <div class="hp-stat-box">
        <span class="hp-stat-n">20 min</span>
        <span class="hp-stat-l">Avg. Ready Time</span>
        </div>
      </div>
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

<!-- Why us -->
<div class="hp-why-section">
  <div class="container">
    <p class="hp-section-pre text-center">Why Choose Us</p>
    <h2 class="hp-section-title text-center mb-5">Food Made with Passion</h2>
    <div class="row g-4">
      <div class="col-md-4">
        <div class="hp-why-card">
          <div class="hp-why-icon">⚡</div>
          <h5>Fast Delivery</h5>
          <p>Hot and fresh, right at your door. We guarantee speed without compromising quality.</p>
        </div>
      </div>
      <div class="col-md-4">
        <div class="hp-why-card hp-why-card--featured">
          <div class="hp-why-icon">👨‍🍳</div>
          <h5>Quality Ingredients</h5>
          <p>Every dish is crafted fresh daily using hand-picked, locally sourced ingredients.</p>
        </div>
      </div>
      <div class="col-md-4">
        <div class="hp-why-card">
          <div class="hp-why-icon">💳</div>
          <h5>Easy Payment</h5>
          <p>Cash, card, or e-wallet — choose any payment method that suits you at checkout.</p>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
