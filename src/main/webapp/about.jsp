<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("pageTitle", "About Us — HotServe");
    String ctx = request.getContextPath();
%>
<jsp:include page="header.jsp" />

<div class="about-hero">
  <div class="container">
    <span class="about-hero-tag">🥗 Our Story</span>
    <h1 class="about-hero-title">Serving Good Food, Made Simple</h1>
    <p class="about-hero-sub">From kitchen to doorstep — meet the platform and the chefs behind HotServe.</p>
  </div>
</div>

<div class="container py-5">
  <div class="row align-items-center g-5">
    <div class="col-md-6">
      <div class="about-img-wrap">
        <img src="https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=700&q=80" alt="Our kitchen">
      </div>
    </div>
    <div class="col-md-6">
      <span class="about-eyebrow">About HotServe</span>
      <h2>Great food, delivered with care</h2>
      <p class="text-muted">HotServe connects you with our partner restaurants' best dishes — from comforting classics to chef-crafted specials — and gets them to your door fresh and fast.</p>
      <p class="text-muted">We built this platform around three things: quality ingredients, transparent pricing, and a smooth ordering experience from browsing to checkout.</p>
    </div>
  </div>

  <div class="row g-4 about-feature-row">
    <div class="col-md-4">
      <div class="about-feature-card">
        <div class="about-feature-icon">🌿</div>
        <h6>Locally Sourced</h6>
        <p class="text-muted small mb-0">Fresh ingredients from trusted local partners</p>
      </div>
    </div>
    <div class="col-md-4">
      <div class="about-feature-card">
        <div class="about-feature-icon">⚡</div>
        <h6>Real-Time Tracking</h6>
        <p class="text-muted small mb-0">Know exactly where your order is, every step</p>
      </div>
    </div>
    <div class="col-md-4">
      <div class="about-feature-card">
        <div class="about-feature-icon">⭐</div>
        <h6>Verified Ratings</h6>
        <p class="text-muted small mb-0">Real reviews from real customers, on every dish</p>
      </div>
    </div>
  </div>

  <div class="about-stats">
    <div class="about-stat"><span class="about-stat-num">50+</span><span class="about-stat-lbl">Partner Restaurants</span></div>
    <div class="about-stat"><span class="about-stat-num">300+</span><span class="about-stat-lbl">Dishes on Menu</span></div>
    <div class="about-stat"><span class="about-stat-num">10k+</span><span class="about-stat-lbl">Happy Customers</span></div>
    <div class="about-stat"><span class="about-stat-num">4.8★</span><span class="about-stat-lbl">Average Rating</span></div>
  </div>

  <div class="section-title mt-5">
    <span class="about-eyebrow">Meet the Kitchen</span>
    <h2>Our Chefs</h2>
    <p>The people behind every dish on HotServe</p>
  </div>
  <div class="row g-4 text-center">
    <div class="col-6 col-md-3">
      <div class="chef-card">
        <div class="chef-avatar">👨‍🍳</div>
        <h6 class="mt-3 mb-1">Head Chef</h6>
        <p class="text-muted small mb-0">Menu design & quality</p>
      </div>
    </div>
    <div class="col-6 col-md-3">
      <div class="chef-card">
        <div class="chef-avatar">👩‍🍳</div>
        <h6 class="mt-3 mb-1">Sous Chef</h6>
        <p class="text-muted small mb-0">Daily kitchen operations</p>
      </div>
    </div>
    <div class="col-6 col-md-3">
      <div class="chef-card">
        <div class="chef-avatar">🧑‍🍳</div>
        <h6 class="mt-3 mb-1">Pastry Chef</h6>
        <p class="text-muted small mb-0">Desserts & baked goods</p>
      </div>
    </div>
    <div class="col-6 col-md-3">
      <div class="chef-card">
        <div class="chef-avatar">👨‍🍳</div>
        <h6 class="mt-3 mb-1">Grill Chef</h6>
        <p class="text-muted small mb-0">Mains & specialties</p>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
