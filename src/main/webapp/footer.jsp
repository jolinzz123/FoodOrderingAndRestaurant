<%
    String ctx = request.getContextPath();
%>
<footer class="site-footer">
  <div class="container">
    <div class="row">
      <div class="col-md-4 mb-3">
        <h5 style="color:#EAE4D8;">🥗 FoodOrder</h5>
        <p>Fresh ingredients, fast delivery, and dishes made with care — straight from our kitchen to your table.</p>
      </div>
      <div class="col-md-4 mb-3">
        <h6 style="color:#EAE4D8;">Quick Links</h6>
        <a href="<%= ctx %>/menu" class="d-block mb-1">Menu</a>
        <a href="<%= ctx %>/about.jsp" class="d-block mb-1">About Us</a>
        <a href="<%= ctx %>/contact.jsp" class="d-block mb-1">Contact</a>
        <a href="<%= ctx %>/faq.jsp" class="d-block mb-1">FAQ</a>
      </div>
      <div class="col-md-4 mb-3">
        <h6 style="color:#EAE4D8;">Contact</h6>
        <p class="mb-1">123 Garden Street, Sepang, Selangor</p>
        <p class="mb-1">hello@foodorder.com</p>
        <p class="mb-1">+60 12-345 6789</p>
      </div>
    </div>
    <hr style="border-color: rgba(255,255,255,0.15);">
    <p class="text-center mb-0" style="font-size:0.85rem;">&copy; 2026 FoodOrder. All rights reserved. | Java EE Assignment Project</p>
  </div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= ctx %>/js/validate.js"></script>
</body>
</html>
