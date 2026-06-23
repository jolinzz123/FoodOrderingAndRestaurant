<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Collection, com.foodorder.model.CartItem, java.math.BigDecimal" %>
<%
    request.setAttribute("pageTitle", "Your Cart — FoodOrder");
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
    Collection<CartItem> cartItems = (Collection<CartItem>) request.getAttribute("cartItems");
    BigDecimal cartTotal = (BigDecimal) request.getAttribute("cartTotal");
    if (cartItems == null) cartItems = java.util.Collections.emptyList();
    if (cartTotal == null) cartTotal = BigDecimal.ZERO;
%>
<jsp:include page="header.jsp" />

<div class="container py-5">
  <h2 class="mb-4">Your Cart</h2>

  <% if (error != null) { %>
    <div class="alert alert-danger"><%= error %></div>
  <% } %>

  <% if (cartItems.isEmpty()) { %>
    <div class="text-center py-5">
      <p class="text-muted">Your cart is empty.</p>
      <a href="<%= ctx %>/menu" class="btn btn-brand">Browse Menu</a>
    </div>
  <% } else { %>
    <div class="row">
      <div class="col-lg-8">
        <table class="table cart-table align-middle">
          <thead>
            <tr><th>Item</th><th>Add-ons</th><th>Quantity</th><th>Subtotal</th><th></th></tr>
          </thead>
          <tbody>
            <% for (CartItem item : cartItems) { %>
              <tr>
                <td><%= item.getFoodName() %></td>
                <td class="text-muted small"><%= (item.getAddons() == null || item.getAddons().isEmpty()) ? "&mdash;" : item.getAddons() %></td>
                <td style="max-width:110px;">
                  <form action="<%= ctx %>/cart" method="post" class="d-flex gap-1">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="foodId" value="<%= item.getFoodId() %>">
                    <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="0" max="20" class="form-control form-control-sm">
                    <button type="submit" class="btn btn-sm btn-outline-brand">Update</button>
                  </form>
                </td>
                <td>RM <%= String.format("%,.2f", item.getSubtotal()) %></td>
                <td>
                  <form action="<%= ctx %>/cart" method="post">
                    <input type="hidden" name="action" value="remove">
                    <input type="hidden" name="foodId" value="<%= item.getFoodId() %>">
                    <button type="submit" class="btn btn-sm btn-outline-danger">Remove</button>
                  </form>
                </td>
              </tr>
            <% } %>
          </tbody>
        </table>
        <form action="<%= ctx %>/cart" method="post">
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

<jsp:include page="footer.jsp" />
