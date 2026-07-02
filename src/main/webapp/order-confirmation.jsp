<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.foodorder.model.OrderItem, java.math.BigDecimal" %>
<%
    request.setAttribute("pageTitle", "Order Confirmed — HotServe");
    String ctx = request.getContextPath();
    Object orderIdObj = request.getAttribute("orderId");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
    BigDecimal orderTotal = (BigDecimal) request.getAttribute("orderTotal");
    if (orderItems == null) orderItems = java.util.Collections.emptyList();
    if (orderTotal == null) orderTotal = BigDecimal.ZERO;
%>
<jsp:include page="header.jsp" />

<div class="container py-5">
  <div class="text-center mb-5">
    <h1 style="color: var(--color-primary);">✅ Order Confirmed!</h1>
    <p class="text-muted">Thank you for your order. Your order number is <strong>#<%= orderIdObj %></strong>.</p>
  </div>

  <div class="row">
    <div class="col-lg-7 mx-auto">
      <table class="table cart-table">
        <thead><tr><th>Item</th><th>Add-ons</th><th>Qty</th><th>Subtotal</th></tr></thead>
        <tbody>
          <% for (OrderItem item : orderItems) { %>
            <tr>
              <td><%= item.getFoodName() %></td>
              <td class="text-muted small"><%= (item.getAddons() == null || item.getAddons().isEmpty()) ? "&mdash;" : item.getAddons() %></td>
              <td><%= item.getQuantity() %></td>
              <td>RM <%= String.format("%,.2f", item.getSubtotal()) %></td>
            </tr>
          <% } %>
        </tbody>
      </table>
      <div class="text-end total-line mb-4">Total Paid: RM <%= String.format("%,.2f", orderTotal) %></div>
      <div class="text-center">
        <a href="<%= ctx %>/menu" class="btn btn-brand">Order More</a>
        <a href="<%= ctx %>/index.jsp" class="btn btn-outline-brand">Back to Home</a>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
