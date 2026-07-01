<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.foodorder.model.*, com.foodorder.util.DBConnection" %>
<%
    request.setAttribute("pageTitle", "Our Menu — FoodOrder");
    String ctx = request.getContextPath();
    List<FoodItem> foodItems = (List<FoodItem>) request.getAttribute("foodItems");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (foodItems == null) foodItems = Collections.emptyList();
    if (categories == null) categories = Collections.emptyList();

    // Group items by category
    LinkedHashMap<String, List<FoodItem>> grouped = new LinkedHashMap<>();
    for (FoodItem fi : foodItems) {
        String cat = fi.getCategoryName() != null ? fi.getCategoryName() : "Other";
        grouped.computeIfAbsent(cat, k -> new ArrayList<>()).add(fi);
    }

    // Cart from session
    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if (cart == null) cart = new LinkedHashMap<>();
    java.math.BigDecimal cartTotal = java.math.BigDecimal.ZERO;
    for (CartItem ci : cart.values()) cartTotal = cartTotal.add(ci.getSubtotal());

    com.foodorder.model.User currentUser = (com.foodorder.model.User) session.getAttribute("user");
%>
<jsp:include page="header.jsp" />

<!-- Category bar -->
<div class="cat-bar">
  <div class="cat-bar-inner">
    <a href="<%= ctx %>/menu"
       class="cat-pill <%= (selectedCategory == null || selectedCategory.isEmpty()) ? "active" : "" %>">
      🍽️ All
    </a>
    <% for (Category cat : categories) {
         boolean active = String.valueOf(cat.getId()).equals(selectedCategory); %>
    <a href="<%= ctx %>/menu?category=<%= cat.getId() %>"
       class="cat-pill <%= active ? "active" : "" %>">
      <%= cat.getName() %>
    </a>
    <% } %>
  </div>
</div>

<!-- 2-panel layout -->
<div class="menu-layout">

  <!-- LEFT: food grid -->
  <div class="menu-food-panel">

    <% if (foodItems.isEmpty()) { %>
      <div class="text-center text-muted py-5">
        <p style="font-size:2rem;">🍽️</p>
        <p>No items found. Try a different category.</p>
      </div>
    <% } else {
         for (Map.Entry<String, List<FoodItem>> entry : grouped.entrySet()) { %>

      <div class="section-label"><%= entry.getKey() %></div>

      <div class="row g-3">
        <% for (FoodItem food : entry.getValue()) { %>
        <div class="col-lg-4 col-md-6 col-sm-6">
          <div class="food-card">
            <div class="food-card-img-wrap">
              <a href="<%= ctx %>/food?id=<%= food.getId() %>">
                <img src="<%= ctx %>/<%= food.getImageUrl() %>"
                     alt="<%= food.getName() %>"
                     onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=70'">
              </a>
            </div>
            <div class="food-card-body">
              <div class="food-card-name">
                <a href="<%= ctx %>/food?id=<%= food.getId() %>" style="color:inherit;"><%= food.getName() %></a>
              </div>
              <div class="food-card-meta">
                <span class="stars" style="font-size:.7rem;">
                  <%
                    double r = food.getRating();
                    for (int s = 1; s <= 5; s++) {
                        if (s <= (int) r) out.print("★");
                        else if (s - r < 1) out.print("✩");
                        else out.print("☆");
                    }
                  %>
                </span>
                <%= String.format("%.1f", food.getRating()) %>
              </div>
              <div class="food-card-footer">
                <span class="food-card-price">RM <%= String.format("%,.2f", food.getPrice()) %></span>
                <% if (currentUser != null) { %>
                <form action="<%= ctx %>/cart" method="post" style="margin:0;">
                  <input type="hidden" name="action" value="add">
                  <input type="hidden" name="foodId" value="<%= food.getId() %>">
                  <input type="hidden" name="quantity" value="1">
                  <input type="hidden" name="returnTo" value="/menu<%= selectedCategory != null && !selectedCategory.isEmpty() ? "?category=" + selectedCategory : "" %>">
                  <button type="submit" class="btn-add-cart" title="Add to cart">+</button>
                </form>
                <% } else { %>
                <a href="<%= ctx %>/login.jsp" class="btn-add-cart" title="Log in to order" style="text-decoration:none;">+</a>
                <% } %>
              </div>
            </div>
          </div>
        </div>
        <% } %>
      </div>

    <% } } %>
  </div><!-- end food panel -->

  <!-- RIGHT: cart sidebar -->
  <div class="menu-cart-panel">
    <div class="cart-sidebar-title">🛒 Your Order</div>

    <% if (cart.isEmpty()) { %>
      <div class="cart-sidebar-empty">
        <span style="font-size:2.5rem;">🛒</span>
        <span>Your cart is empty</span>
        <span style="font-size:.8rem;">Add items from the menu</span>
      </div>
    <% } else { %>
      <div style="flex:1; overflow-y:auto;">
        <% for (CartItem ci : cart.values()) {
             String thumb = ci.getImageUrl();
             if (thumb == null || thumb.isEmpty()) {
               thumb = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&q=70";
             } else if (!thumb.startsWith("http")) {
               thumb = ctx + "/" + thumb;
             }
        %>
        <div class="cart-sidebar-item">
          <img src="<%= thumb %>" alt="<%= ci.getFoodName() %>"
               onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&q=70'">
          <div class="cart-sidebar-item-info">
            <div class="cart-sidebar-item-name"><%= ci.getFoodName() %></div>
            <div class="cart-sidebar-item-cat">
              <%= (ci.getAddons() == null || ci.getAddons().isEmpty()) ? "No add-ons" : ci.getAddons() %>
            </div>
            <div class="cart-sidebar-qty">
              <!-- update qty form -->
              <form action="<%= ctx %>/cart" method="post" style="display:flex;align-items:center;gap:6px;margin:0;">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="foodId" value="<%= ci.getFoodId() %>">
                <input type="hidden" name="returnTo" value="/menu<%= selectedCategory != null && !selectedCategory.isEmpty() ? "?category=" + selectedCategory : "" %>">
                <button type="submit" name="quantity" value="<%= ci.getQuantity() - 1 %>" class="cart-sidebar-qty-btn">−</button>
                <span class="cart-sidebar-qty-num"><%= ci.getQuantity() %></span>
                <button type="submit" name="quantity" value="<%= ci.getQuantity() + 1 %>" class="cart-sidebar-qty-btn">+</button>
              </form>
            </div>
          </div>
          <div class="cart-sidebar-item-price">RM <%= String.format("%,.2f", ci.getSubtotal()) %></div>
        </div>
        <% } %>
      </div>

      <!-- Summary -->
      <div class="cart-sidebar-summary">
        <div class="cart-summary-row">
          <span>Subtotal (<%= cart.size() %> item<%= cart.size()==1?"":"s" %>)</span>
          <span>RM <%= String.format("%,.2f", cartTotal) %></span>
        </div>
        <div class="cart-summary-row">
          <span>Delivery Fee</span>
          <span>RM 0.00</span>
        </div>
        <div class="cart-summary-total">
          <span>Total</span>
          <span>RM <%= String.format("%,.2f", cartTotal) %></span>
        </div>

        <!-- Payment method (visual selection only — actual selection at checkout) -->
        <div style="font-size:.78rem; font-weight:600; color:var(--color-text-muted); margin-bottom:8px;">Payment Method</div>
        <div class="pay-methods">
          <div class="pay-method-btn active">
            <span class="pay-method-icon">💵</span>
            <span>Cash</span>
          </div>
          <div class="pay-method-btn">
            <span class="pay-method-icon">💳</span>
            <span>Debit</span>
          </div>
          <div class="pay-method-btn">
            <span class="pay-method-icon">📱</span>
            <span>QR</span>
          </div>
        </div>

        <% if (currentUser != null) { %>
          <a href="<%= ctx %>/checkout" class="btn-checkout">Process Transaction →</a>
        <% } else { %>
          <a href="<%= ctx %>/login.jsp" class="btn-checkout">Log in to Checkout →</a>
        <% } %>
      </div>
    <% } %>
  </div><!-- end cart panel -->

</div><!-- end menu-layout -->

<script>
  // Payment method button toggle
  document.querySelectorAll('.pay-method-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
      document.querySelectorAll('.pay-method-btn').forEach(b => b.classList.remove('active'));
      this.classList.add('active');
    });
  });
</script>

<jsp:include page="footer.jsp" />
