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
%>
<jsp:include page="header.jsp" />

<div class="cart-page-hero">
  <span style="font-size:1.6rem;">🛒</span>
  <div>
    <h1>Your Cart</h1>
    <p><%= cartItems.size() %> item<%= cartItems.size() == 1 ? "" : "s" %> ready for checkout</p>
  </div>
</div>

<div class="container pb-5">

  <% if (error != null) { %>
    <div class="alert alert-danger"><%= error %></div>
  <% } %>

  <% if (cartItems.isEmpty()) { %>
    <div class="empty-cart">
      <div class="icon">&#128722;</div>
      <p class="text-muted mb-3">Your cart is empty.</p>
      <a href="<%= ctx %>/menu" class="btn btn-brand">Browse Menu</a>
    </div>
  <% } else { %>
    <div class="row">
      <div class="col-lg-8">

        <% for (CartItem item : cartItems) { %>
          <div class="cart-item-row">
            <%
              String thumb = item.getImageUrl();
              if (thumb == null || thumb.isEmpty()) {
                  thumb = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&q=80";
              } else if (!thumb.startsWith("http")) {
                  thumb = ctx + "/" + thumb;
              }
            %>
            <img src="<%= thumb %>" alt="<%= item.getFoodName() %>"
                 onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&q=80'">

            <div class="cart-item-info">
              <h6><%= item.getFoodName() %></h6>
              <div class="cart-item-addons">
                <%= (item.getAddons() == null || item.getAddons().isEmpty()) ? "No add-ons" : item.getAddons() %>
              </div>
            </div>

            <form action="<%= ctx %>/cart" method="post" class="d-flex align-items-center gap-2" style="margin:0;">
              <input type="hidden" name="action" value="update">
              <input type="hidden" name="cartKey" value="<%= item.getCartKey() %>">
              <div class="qty-ctrl">
                <button type="button" class="qty-btn" onclick="stepQty(this,-1)">&minus;</button>
                <input class="qty-num" type="number" name="quantity" value="<%= item.getQuantity() %>" min="0" max="20">
                <button type="button" class="qty-btn" onclick="stepQty(this,1)">+</button>
              </div>
              <button type="submit" class="btn btn-sm btn-outline-brand">Update</button>
            </form>

            <span class="cart-item-price">RM <%= String.format("%,.2f", item.getSubtotal()) %></span>

            <form action="<%= ctx %>/cart" method="post" style="margin:0;">
              <input type="hidden" name="action" value="remove">
              <input type="hidden" name="cartKey" value="<%= item.getCartKey() %>">
              <button type="submit" class="btn btn-sm btn-outline-danger">Remove</button>
            </form>
          </div>
        <% } %>

        <form action="<%= ctx %>/cart" method="post" class="mt-2">
          <input type="hidden" name="action" value="clear">
          <button type="submit" class="btn btn-sm btn-outline-danger">Clear Cart</button>
        </form>
      </div>

      <div class="col-lg-4">
        <div class="cart-summary">
          <h5 class="mb-3">Order Summary</h5>
          <div class="d-flex justify-content-between total-line">
            <span>Total</span>
            <span>RM <%= String.format("%,.2f", cartTotal) %></span>
          </div>
          <a href="<%= ctx %>/checkout" class="btn btn-brand w-100 mt-4">Proceed to Checkout</a>
        </div>
      </div>
    </div>
  <% } %>
</div>

<script>
  function stepQty(btn, delta) {
    var ctrl = btn.closest('.qty-ctrl');
    var input = ctrl.querySelector('.qty-num');
    var val = parseInt(input.value || '1') + delta;
    if (val < 0) val = 0;
    if (val > 20) val = 20;
    input.value = val;
  }
</script>

<jsp:include page="footer.jsp" />
