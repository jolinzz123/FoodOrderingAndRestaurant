<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.foodorder.dao.FoodDAO, com.foodorder.model.FoodItem, java.util.List, java.util.Comparator" %>
<%
    request.setAttribute("pageTitle", "FoodOrder — Home");
    List<FoodItem> all = new FoodDAO().findAll();
    all.sort(Comparator.comparingDouble(FoodItem::getRating).reversed());
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
          <img src="<%= ctx %>/images/main.png"
               alt="Featured dish"
               class="hp-hero-img"
               onerror="this.src='https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=600&q=85'">
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

</section>

<div class="hp-promo-banner">
  <div class="container hp-promo-inner">
    <span class="hp-promo-icon">🔥</span>
    <span class="hp-promo-text">Spend RM30 or more and enjoy FREE delivery — every day!</span>
    <a href="<%= ctx %>/menu" class="hp-promo-cta">Order now →</a>
  </div>
</div>

<div class="hp-stats-bar" style="background:#F5F3FF;">
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
        <span class="hp-stat-n">RM3</span>
        <span class="hp-stat-l">Delivery Fee</span>
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
    <%
      
      String[] featuredNames = {
          "Chicken Rice", "Fried Rice", "Nasi Lemak Special",
          "Nasi Dagang", "Asam Laksa", "Laksa Lemak"
      };
      String[] featuredImages = {
          "images/chickenrice.png", "images/friedrice.png", "images/nasilemak.png",
          "images/nasidagang.png", "images/asamlaksa.png", "images/laksalemak.png"
      };
      List<FoodItem> featured = new java.util.ArrayList<>();
      for (String fname : featuredNames) {
        for (FoodItem it : all) {
          if (it.getName().equalsIgnoreCase(fname)) { featured.add(it); break; }
        }
      }
    %>
    <% if (featured.isEmpty()) { %>
      <p class="text-muted">No items found. <a href="<%= ctx %>/menu">Browse menu</a></p>
    <% } else {
        for (int i = 0; i < featured.size(); i++) {
          FoodItem item = featured.get(i);
    %>
    <a href="<%= ctx %>/food?id=<%= item.getId() %>" class="hp-dish-card">
      <div class="hp-dish-img-wrap">
        <img src="<%= ctx %>/<%= featuredImages[i] %>"
             alt="<%= item.getName() %>"
             onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=70'">
      </div>
      <div class="hp-dish-body">
        <span class="hp-dish-cat"><%= item.getCategoryName() != null ? item.getCategoryName() : "Uncategorized" %></span>
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

<!-- New Arrivals -->
<div class="container py-4">
  <div class="d-flex align-items-end justify-content-between mb-4">
    <div>
      <p class="hp-section-pre">Just Added</p>
      <h2 class="hp-section-title">New Arrivals</h2>
    </div>
  </div>
  <div class="hp-dishes-grid">
    <%
      
      String[] newArrivalNames = { "Ayam Percik", "Roti Canai", "Egg Roti" };
      String[] newArrivalImages = {
          "images/ayampercik.png", "images/roticanai.png", "images/eggroti.png"
      };
      List<FoodItem> newItems = new java.util.ArrayList<>();
      for (String naname : newArrivalNames) {
        for (FoodItem it : all) {
          if (it.getName().equalsIgnoreCase(naname)) { newItems.add(it); break; }
        }
      }
      for (int i = 0; i < newItems.size(); i++) {
        FoodItem item = newItems.get(i);
    %>
    <a href="<%= ctx %>/food?id=<%= item.getId() %>" class="hp-dish-card">
      <div class="hp-dish-img-wrap">
        <span class="hp-dish-new-badge">NEW</span>
        <img src="<%= ctx %>/<%= newArrivalImages[i] %>"
             alt="<%= item.getName() %>"
             onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=70'">
      </div>
      <div class="hp-dish-body">
        <span class="hp-dish-cat"><%= item.getCategoryName() != null ? item.getCategoryName() : "Uncategorized" %></span>
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


<!-- Testimonials -->
<div class="hp-testimonials-section">
  <div class="container">
    <p class="hp-section-pre text-center">What They Say</p>
    <h2 class="hp-section-title text-center mb-5">Customer Reviews</h2>
    <div class="hp-testimonials-grid">
      <div class="hp-testimonial-card">
        <p class="hp-testimonial-text">The flavors are so authentic and the portions are generous — our go-to order every week!</p>
        <div class="hp-testimonial-person">
          <img src="https://i.pravatar.cc/40?img=15" alt="Customer avatar" class="hp-testimonial-avatar">
          <div class="hp-testimonial-info">
            <div class="hp-testimonial-name-row">
              <span class="hp-testimonial-name">Wei Ling</span>
              <span class="hp-testimonial-stars">★★★★★</span>
            </div>
            <div class="hp-testimonial-role">Regular · 3 years</div>
          </div>
        </div>
      </div>
      <div class="hp-testimonial-card">
        <p class="hp-testimonial-text">Delivery is always fast and the food still arrives hot. Packaging is thoughtful too.</p>
        <div class="hp-testimonial-person">
          <img src="https://i.pravatar.cc/40?img=32" alt="Customer avatar" class="hp-testimonial-avatar">
          <div class="hp-testimonial-info">
            <div class="hp-testimonial-name-row">
              <span class="hp-testimonial-name">Ah Meng</span>
              <span class="hp-testimonial-stars">★★★★★</span>
            </div>
            <div class="hp-testimonial-role">Regular · 1 year</div>
          </div>
        </div>
      </div>
      <div class="hp-testimonial-card">
        <p class="hp-testimonial-text">Great value, generous portions, and their signature dish never gets old.</p>
        <div class="hp-testimonial-person">
          <img src="https://i.pravatar.cc/40?img=47" alt="Customer avatar" class="hp-testimonial-avatar">
          <div class="hp-testimonial-info">
            <div class="hp-testimonial-name-row">
              <span class="hp-testimonial-name">Siti</span>
              <span class="hp-testimonial-stars">★★★★★</span>
            </div>
            <div class="hp-testimonial-role">Regular · 2 years</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Our Story -->
<div class="hp-about-simple">
  <div class="container">
    <div class="hp-about-simple-inner">
      <p class="hp-section-pre">Our Story</p>
      <h2 class="hp-section-title mb-3">Started in our home kitchen</h2>
      <p class="hp-about-desc">
        HotServe began in a small home kitchen, with one simple rule: every dish is made
        fresh, every day, from real ingredients — no shortcuts, no pre-made mixes.
        We believe great flavor comes from care, not a production line.
      </p>
      <a href="<%= ctx %>/about.jsp" class="hp-btn-outline">Read our full story</a>
    </div>
  </div>
</div>

<!-- Why us -->
<div class="hp-why-section" style="background:#F5F3FF!important;">
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
