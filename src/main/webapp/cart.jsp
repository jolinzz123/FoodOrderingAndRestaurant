<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection, com.foodorder.model.CartItem, java.math.BigDecimal" %>
<%
    request.setAttribute("pageTitle", "Your Cart — HotServe");
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
    Collection<CartItem> cartItems = (Collection<CartItem>) request.getAttribute("cartItems");
    BigDecimal cartTotal = (BigDecimal) request.getAttribute("cartTotal");
    if (cartItems == null) cartItems = java.util.Collections.emptyList();
    if (cartTotal == null) cartTotal = BigDecimal.ZERO;

    BigDecimal deliveryFee = cartTotal.compareTo(new BigDecimal("30.00")) >= 0
        ? BigDecimal.ZERO : new BigDecimal("3.00");
    BigDecimal grandTotal = cartTotal.add(deliveryFee);
%>
<jsp:include page="header.jsp" />

<!-- Hero banner -->
<div class="cp-hero">
  <div class="container cp-hero-inner">
    <div class="cp-hero-left">
      <div class="cp-hero-icon">🛒</div>
      <div>
        <h1 class="cp-hero-title">Your Cart</h1>
        <p class="cp-hero-sub"><%= cartItems.size() %> item<%= cartItems.size() == 1 ? "" : "s" %> ready for checkout</p>
      </div>
    </div>
    <a href="<%= ctx %>/menu" class="cp-hero-back">← Continue Shopping</a>
  </div>
</div>

<div class="container cp-body">

  <% if (error != null) { %>
    <div class="alert alert-danger mb-4"><%= error %></div>
  <% } %>

  <% if (cartItems.isEmpty()) { %>
    <div class="cp-empty">
      <div class="cp-empty-icon">🛒</div>
      <h4>Your cart is empty</h4>
      <p>Looks like you haven't added anything yet.</p>
      <a href="<%= ctx %>/menu" class="cp-empty-btn">Browse Menu</a>
    </div>

  <% } else { %>
  <div class="cp-grid">

    <!-- LEFT: item list -->
    <div class="cp-items-col">

      <% for (CartItem item : cartItems) {
           String thumb = item.getImageUrl();
           if (thumb == null || thumb.isEmpty()) {
               thumb = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&q=80";
           } else if (!thumb.startsWith("http")) {
               thumb = ctx + "/" + thumb;
           }
           String addonsDisplay = (item.getAddons() == null || item.getAddons().isEmpty()) ? "No add-ons" : item.getAddons();
      %>
      <div class="cp-item-card">
        <!-- Image -->
        <div class="cp-item-img-wrap">
          <img src="<%= thumb %>" alt="<%= item.getFoodName() %>"
               onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&q=80'">
        </div>

        <!-- Name + addons -->
        <div class="cp-item-info">
          <div class="cp-item-name"><%= item.getFoodName() %></div>
          <div class="cp-item-addons"><%= addonsDisplay %></div>
          <a href="<%= ctx %>/food?id=<%= item.getFoodId() %>&editKey=<%= java.net.URLEncoder.encode(item.getCartKey(), "UTF-8") %>"
             class="cp-edit-link">✏️ Edit add-ons</a>
        </div>

        <!-- Qty control -->
        <form action="<%= ctx %>/cart" method="post" class="cp-qty-form" id="qtyForm_<%= item.getFoodId() %>">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="cartKey" value="<%= item.getCartKey() %>">
          <div class="cp-qty-ctrl">
            <button type="button" class="cp-qty-btn" onclick="stepAndSubmit(this,-1)">−</button>
            <span class="cp-qty-num"><%= item.getQuantity() %></span>
            <button type="button" class="cp-qty-btn" onclick="stepAndSubmit(this,1)">+</button>
            <input type="hidden" name="quantity" class="cp-qty-hidden" value="<%= item.getQuantity() %>">
          </div>
        </form>

        <!-- Price -->
        <div class="cp-item-price">RM <%= String.format("%,.2f", item.getSubtotal()) %></div>

        <!-- Remove -->
        <form action="<%= ctx %>/cart" method="post" class="cp-remove-form">
          <input type="hidden" name="action" value="remove">
          <input type="hidden" name="cartKey" value="<%= item.getCartKey() %>">
          <button type="submit" class="cp-remove-btn" title="Remove">🗑</button>
        </form>
      </div>
      <% } %>

      <form action="<%= ctx %>/cart" method="post" class="cp-clear-row">
        <input type="hidden" name="action" value="clear">
        <button type="submit" class="cp-clear-btn">🗑 Clear all items</button>
      </form>
    </div>

    <!-- RIGHT: order summary -->
    <div class="cp-summary-col">
      <div class="cp-summary-card">
        <div class="cp-summary-title">Order Summary</div>

        <!-- item breakdown with add-ons -->
        <div class="cp-summary-items">
          <% for (CartItem item : cartItems) {
               String addons = (item.getAddons() == null || item.getAddons().isEmpty()) ? null : item.getAddons();
          %>
          <div class="cp-summary-item">
            <div class="cp-summary-item-left">
              <span class="cp-summary-item-name"><%= item.getFoodName() %> × <%= item.getQuantity() %></span>
              <% if (addons != null) { %>
              <span class="cp-summary-item-addons"><%= addons %></span>
              <% } %>
            </div>
            <span class="cp-summary-item-price">RM <%= String.format("%,.2f", item.getSubtotal()) %></span>
          </div>
          <% } %>
        </div>

        <div class="cp-summary-divider"></div>

        <div class="cp-summary-row">
          <span>Subtotal</span>
          <span>RM <%= String.format("%,.2f", cartTotal) %></span>
        </div>
        <div class="cp-summary-row">
          <span>Delivery Fee</span>
          <span class="<%= deliveryFee.compareTo(BigDecimal.ZERO) == 0 ? "cp-free" : "" %>">
            <%= deliveryFee.compareTo(BigDecimal.ZERO) == 0 ? "FREE 🎉" : "RM " + String.format("%,.2f", deliveryFee) %>
          </span>
        </div>
        <% if (deliveryFee.compareTo(BigDecimal.ZERO) > 0) { %>
        <div class="cp-delivery-hint">
          Spend RM <%= String.format("%.2f", new BigDecimal("30.00").subtract(cartTotal)) %> more for free delivery
        </div>
        <% } %>

        <div class="cp-summary-divider"></div>

        <div class="cp-summary-total">
          <span>Total</span>
          <span>RM <%= String.format("%,.2f", grandTotal) %></span>
        </div>

        <!-- Payment method selector -->
        <div class="cp-pay-label">Payment Method</div>
        <div class="cp-pay-grid">
          <div class="cp-pay-btn active" data-pay="cod">
            <span class="cp-pay-icon">💵</span>
            <span class="cp-pay-name">Cash</span>
          </div>
          <div class="cp-pay-btn" data-pay="card">
            <span class="cp-pay-icon">💳</span>
            <span class="cp-pay-name">Card</span>
          </div>
          <div class="cp-pay-btn" data-pay="ewallet">
            <span class="cp-pay-icon">📱</span>
            <span class="cp-pay-name">E-Wallet</span>
          </div>
        </div>

        <a href="<%= ctx %>/checkout" class="cp-checkout-btn">Proceed to Checkout →</a>
      </div>
    </div>

  </div>
  <% } %>
</div>

<script>
  function stepAndSubmit(btn, delta) {
    var ctrl = btn.closest('.cp-qty-ctrl');
    var display = ctrl.querySelector('.cp-qty-num');
    var hidden  = ctrl.querySelector('.cp-qty-hidden');
    var val = parseInt(hidden.value || '1') + delta;
    if (val < 0) val = 0;
    if (val > 20) val = 20;
    hidden.value = val;
    display.textContent = val;
    btn.closest('form').submit();
  }

  // Payment method toggle with localStorage persistence
  (function() {
    var saved = localStorage.getItem('selectedPayment') || 'cod';
    var btns = document.querySelectorAll('.cp-pay-btn');
    btns.forEach(function(btn) {
      if (btn.dataset.pay === saved) btn.classList.add('active');
      else btn.classList.remove('active');
      btn.addEventListener('click', function() {
        btns.forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        localStorage.setItem('selectedPayment', btn.dataset.pay);
      });
    });
  })();
</script>

<jsp:include page="footer.jsp" />
