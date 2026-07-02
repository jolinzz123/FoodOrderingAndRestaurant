<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.CartItem, java.util.Map, java.util.LinkedHashMap, java.math.BigDecimal" %>
<%
    request.setAttribute("pageTitle", "Checkout — FoodOrder");
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");

    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if (cart == null) cart = new LinkedHashMap<>();
    BigDecimal cartTotal = BigDecimal.ZERO;
    for (CartItem ci : cart.values()) cartTotal = cartTotal.add(ci.getSubtotal());
%>
<jsp:include page="header.jsp" />

<style>
.co-item-list { display: flex; flex-direction: column; gap: 12px; margin-bottom: 24px; }
.co-item-row {
  display: flex; align-items: center; gap: 14px;
  background: #fff; border: 1px solid var(--color-border);
  border-radius: 12px; padding: 12px 14px;
}
.co-item-img { width: 64px; height: 64px; object-fit: cover; border-radius: 8px; flex-shrink: 0; }
.co-item-info { flex: 1; min-width: 0; }
.co-item-name { font-weight: 700; font-size: 0.95rem; color: var(--color-text); }
.co-item-addons { font-size: 0.78rem; color: var(--color-text-muted); margin-top: 2px; }
.co-item-qty { font-size: 0.82rem; color: var(--color-text-muted); margin-top: 2px; }
.co-item-price { font-weight: 700; color: var(--color-primary); white-space: nowrap; font-size: 0.95rem; }
.co-remove-form { margin: 0; }
.co-remove-btn {
  background: none; border: 1px solid #f0b0b0; border-radius: 8px;
  color: #d9534f; font-size: 1.1rem; width: 36px; height: 36px;
  display: flex; align-items: center; justify-content: center; cursor: pointer;
  transition: background 0.15s, color 0.15s;
}
.co-remove-btn:hover { background: #fff0f0; border-color: #d9534f; }
</style>

<div class="container py-5">
  <h2 class="mb-4">Checkout</h2>

  <% if (error != null) { %>
    <div class="alert alert-danger"><%= error %></div>
  <% } %>

  <% if (cart.isEmpty()) { %>
    <div class="text-center py-5">
      <p class="text-muted">Your cart is empty — add some items before checking out.</p>
      <a href="<%= ctx %>/menu" class="btn btn-brand">Browse Menu</a>
    </div>
  <% } else { %>
    <div class="row">
      <div class="col-lg-7">
        <h5 class="mb-3">Order Review</h5>
        <div class="co-item-list">
          <% for (CartItem item : cart.values()) { %>
          <div class="co-item-row">
            <img src="<%= ctx %>/<%= item.getImageUrl() %>"
                 alt="<%= item.getFoodName() %>"
                 class="co-item-img"
                 onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=80&q=70'">
            <div class="co-item-info">
              <div class="co-item-name"><%= item.getFoodName() %></div>
              <% if (item.getAddons() != null && !item.getAddons().isEmpty()) { %>
                <div class="co-item-addons"><%= item.getAddons() %></div>
              <% } %>
              <div class="co-item-qty">Qty: <%= item.getQuantity() %></div>
            </div>
            <div class="co-item-price">RM <%= String.format("%,.2f", item.getSubtotal()) %></div>
            <form action="<%= ctx %>/cart" method="post" class="co-remove-form">
              <input type="hidden" name="action" value="remove">
              <input type="hidden" name="foodId" value="<%= item.getFoodId() %>">
              <input type="hidden" name="returnTo" value="/checkout">
              <button type="submit" class="co-remove-btn" title="Remove item">&#x1F5D1;</button>
            </form>
          </div>
          <% } %>
        </div>
      </div>
      <div class="col-lg-5">
        <div class="cart-summary">
          <h5 class="mb-3">Payment Summary</h5>
          <div class="d-flex justify-content-between mb-2">
            <span>Subtotal</span><span>RM <%= String.format("%,.2f", cartTotal) %></span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <span>Delivery Fee</span><span>RM 0.00</span>
          </div>
          <hr>
          <div class="d-flex justify-content-between total-line mb-3">
            <span>Total</span><span>RM <%= String.format("%,.2f", cartTotal) %></span>
          </div>
          <form action="<%= ctx %>/checkout" method="post" id="checkoutForm">
            <div class="mb-3">
              <label class="form-label">Delivery Address</label>
              <input type="text" class="form-control" name="address" placeholder="Enter your delivery address" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Payment Method</label>
              <select class="form-select" name="paymentMethod" required>
                <option value="cod">Cash on Delivery</option>
                <option value="card">Credit / Debit Card</option>
                <option value="ewallet">E-Wallet</option>
              </select>
            </div>
            <button type="submit" class="btn btn-brand w-100">Place Order</button>
          </form>
        </div>
      </div>
    </div>
  <% } %>
</div>

<jsp:include page="footer.jsp" />
