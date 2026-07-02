<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.foodorder.model.*, com.foodorder.util.DBConnection" %>
<%
    request.setAttribute("pageTitle", "Our Menu — HotServe");
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
    Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
    if (cart == null) cart = new LinkedHashMap<>();
    java.math.BigDecimal cartTotal = java.math.BigDecimal.ZERO;
    for (CartItem ci : cart.values()) cartTotal = cartTotal.add(ci.getSubtotal());

    com.foodorder.model.User currentUser = (com.foodorder.model.User) session.getAttribute("user");
%>
<jsp:include page="header.jsp" />

<style>
.cat-bar-inner {
  display: flex !important;
  flex-wrap: nowrap !important;
  overflow-x: auto !important;
  overflow-y: hidden !important;
  scrollbar-width: none !important;
  gap: 8px !important;
  padding: 2px 16px !important;
  width: 100% !important;
  box-sizing: border-box !important;
}
.cat-bar-inner::-webkit-scrollbar { display: none !important; }
.cat-pill {
  flex-shrink: 0 !important;
  white-space: nowrap !important;
  padding: 5px 11px !important;
  font-size: .75rem !important;
}
</style>

<!-- Category bar -->
<div class="cat-bar">
  <div class="cat-bar-inner" style="display:flex;flex-wrap:nowrap;overflow-x:auto;overflow-y:hidden;gap:8px;padding:2px 16px;width:100%;box-sizing:border-box;scrollbar-width:none;justify-content:center;">
    <a href="<%= ctx %>/menu"
       class="cat-pill <%= (selectedCategory == null || selectedCategory.isEmpty()) ? "active" : "" %>">
      🍽️ All
    </a>
    <%
       java.util.Map<String,String> catEmoji = new java.util.HashMap<>();
       catEmoji.put("Rice",           "🍚");
       catEmoji.put("Nasi",           "🍚");
       catEmoji.put("Noodles",        "🍜");
       catEmoji.put("Mee",            "🍜");
       catEmoji.put("Bread & FlatBread","🫓");
       catEmoji.put("Roti",           "🫓");
       catEmoji.put("Main Dishes", "🍖");
       catEmoji.put("MainDishes",  "🍖");
       catEmoji.put("Lauk",           "🍖");
       catEmoji.put("Vegetables",     "🥦");
       catEmoji.put("Sayur",          "🥦");
       catEmoji.put("Western",        "🍔");
       catEmoji.put("Desserts",       "🍮");
       catEmoji.put("Drinks",         "🧋");
       for (Category cat : categories) {
         boolean active = String.valueOf(cat.getId()).equals(selectedCategory);
         String emoji = catEmoji.getOrDefault(cat.getName(), "🍴");
    %>
    <a href="<%= ctx %>/menu?category=<%= cat.getId() %>"
       class="cat-pill <%= active ? "active" : "" %>">
      <%= emoji %> <%= cat.getName() %>
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
        <%
          int soldCount = 10 + (food.getId() * 7 % 41);
          boolean isHot = soldCount >= 45;
        %>
        <div class="col-lg-4 col-md-6 col-sm-6">
          <div class="food-card">
            <!-- image -->
            <div class="food-card-img-wrap">
              <a href="<%= ctx %>/food?id=<%= food.getId() %>" class="food-card-img-link">
                <img src="<%= ctx %>/<%= food.getImageUrl() %>"
                     alt="<%= food.getName() %>"
                     onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=70'">
              </a>
            </div>
            <!-- card info -->
            <div class="food-card-body">
              <div class="food-card-name">
                <a href="<%= ctx %>/food?id=<%= food.getId() %>"><%= food.getName() %></a>
              </div>
              <div class="food-card-meta">
                <span class="food-card-stars">
                  <%
                    double r = food.getRating();
                    for (int s = 1; s <= 5; s++) {
                        if (s <= (int) r) out.print("★");
                        else out.print("☆");
                    }
                  %>
                </span>
                <span class="food-card-rating-num"><%= String.format("%.1f", food.getRating()) %></span>
                <span class="food-card-dot">·</span>
                <span class="food-card-sold"><%= soldCount %> sold</span>
                <% if (isHot) { %><span class="food-card-bestseller">⭐ Best Seller</span><% } %>
              </div>
              <div class="food-card-footer">
                <span class="food-card-price">RM <%= String.format("%,.2f", food.getPrice()) %></span>
                <% if (currentUser != null) { %>
                <form action="<%= ctx %>/cart" method="post" class="food-card-cart-form">
                  <input type="hidden" name="action" value="add">
                  <input type="hidden" name="foodId" value="<%= food.getId() %>">
                  <input type="hidden" name="quantity" value="1">
                  <button type="submit" class="btn-add-cart" title="Add to cart">&#128722;</button>
                </form>
                <% } else { %>
                <a href="<%= ctx %>/login.jsp" class="btn-add-cart" title="Log in to order">&#128722;</a>
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
                <input type="hidden" name="cartKey" value="<%= ci.getCartKey() %>">
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
          <div class="pay-method-btn active" data-pay="cod">
            <span class="pay-method-icon">💵</span>
            <span>Cash</span>
          </div>
          <div class="pay-method-btn" data-pay="card">
            <span class="pay-method-icon">💳</span>
            <span>Debit</span>
          </div>
          <div class="pay-method-btn" data-pay="ewallet">
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
(function() {
  var cartPanel = document.querySelector('.menu-cart-panel');
  var menuUrl = window.location.href;

  function cartFetch(action, key, quantity, isCartKey) {
    var params = new URLSearchParams({ action: action });
    if (isCartKey) params.set('cartKey', key);
    else params.set('foodId', key);
    if (quantity !== undefined) params.set('quantity', quantity);
    return fetch('<%= ctx %>/cart', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: params.toString(),
      credentials: 'same-origin',
      redirect: 'follow'
    });
  }

  function refreshSidebar() {
    fetch(menuUrl, { credentials: 'same-origin' })
      .then(function(r) { return r.text(); })
      .then(function(html) {
        var tmp = document.createElement('div');
        tmp.innerHTML = html;
        var fresh = tmp.querySelector('.menu-cart-panel');
        if (fresh && cartPanel) {
          cartPanel.innerHTML = fresh.innerHTML;
          bindSidebarQty();
          bindPaymentBtns();
        }
      });
  }

  // Add-to-cart buttons (food grid)
  document.querySelectorAll('.food-card-footer form[action*="/cart"]').forEach(function(form) {
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      var foodId = form.querySelector('[name="foodId"]').value;
      var btn = form.querySelector('.btn-add-cart');
      if (btn) { var orig = btn.innerHTML; btn.textContent = '✓'; btn.disabled = true; setTimeout(function(){ btn.innerHTML = orig; btn.disabled = false; }, 900); }
      cartFetch('add', foodId, 1, false).then(refreshSidebar);
    });
  });

  // Qty +/− buttons in sidebar (bound fresh each refresh)
  function bindSidebarQty() {
    cartPanel.querySelectorAll('button[name="quantity"]').forEach(function(btn) {
      btn.addEventListener('click', function(e) {
        e.preventDefault(); // stop form submit
        var form = btn.closest('form');
        var cartKey = form.querySelector('[name="cartKey"]').value;
        cartFetch('update', cartKey, btn.value, true).then(refreshSidebar);
      });
    });
  }

  function bindPaymentBtns() {
    // Restore saved choice
    var saved = localStorage.getItem('selectedPayment') || 'cod';
    cartPanel.querySelectorAll('.pay-method-btn').forEach(function(btn) {
      btn.classList.toggle('active', btn.dataset.pay === saved);
      btn.addEventListener('click', function() {
        cartPanel.querySelectorAll('.pay-method-btn').forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        localStorage.setItem('selectedPayment', btn.dataset.pay || 'cod');
      });
    });
  }

  bindSidebarQty();
  bindPaymentBtns();
})();
</script>

<jsp:include page="footer.jsp" />
