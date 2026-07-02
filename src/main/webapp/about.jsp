<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("pageTitle", "About Us — HotServe");
    String ctx = request.getContextPath();
%>
<jsp:include page="header.jsp" />

<div class="container py-5">
  <div class="row align-items-center g-5">
    <div class="col-md-6">
      <img src="https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=700&q=80" class="img-fluid rounded-4 shadow-sm" alt="Our kitchen">
    </div>
    <div class="col-md-6">
      <h2>About HotServe</h2>
      <p class="text-muted">HotServe connects you with our partner restaurants' best dishes — from comforting classics to chef-crafted specials — and gets them to your door fresh and fast.</p>
      <p class="text-muted">We built this platform around three things: quality ingredients, transparent pricing, and a smooth ordering experience from browsing to checkout.</p>
      <ul class="list-unstyled text-muted">
        <li class="mb-2">🌿 Locally sourced ingredients wherever possible</li>
        <li class="mb-2">⚡ Real-time order tracking and management</li>
        <li class="mb-2">⭐ Verified customer ratings on every dish</li>
      </ul>
    </div>
  </div>

  <div class="section-title mt-5">
    <h2>Our Team</h2>
    <p>The people behind HotServe</p>
  </div>
  <div class="row g-4 text-center">
    <div class="col-md-3">
      <div class="card-food p-3"><h6 class="mt-2">Front-End Team</h6><p class="text-muted small">Pages, styling & UX</p></div>
    </div>
    <div class="col-md-3">
      <div class="card-food p-3"><h6 class="mt-2">Back-End Team</h6><p class="text-muted small">Servlets, DB & auth</p></div>
    </div>
    <div class="col-md-3">
      <div class="card-food p-3"><h6 class="mt-2">QA Team</h6><p class="text-muted small">Testing & validation</p></div>
    </div>
    <div class="col-md-3">
      <div class="card-food p-3"><h6 class="mt-2">Project Lead</h6><p class="text-muted small">Coordination & docs</p></div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
