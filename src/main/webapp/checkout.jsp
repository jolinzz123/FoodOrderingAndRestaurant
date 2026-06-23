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
        <table class="table cart-table">
          <thead><tr><th>Item</th><th>Add-ons</th><th>Qty</th><th>Subtotal</th></tr></thead>
          <tbody>
            <% for (CartItem item : cart.values()) { %>
              <tr>
                <td><%= item.getFoodName() %></td>
                <td class="text-muted small"><%= (item.getAddons() == null || item.getAddons().isEmpty()) ? "&mdash;" : item.getAddons() %></td>
                <td><%= item.getQuantity() %></td>
                <td>RM <%= String.format("%,.2f", item.getSubtotal()) %></td>
              </tr>
            <% } %>
          </tbody>
        </table>
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
