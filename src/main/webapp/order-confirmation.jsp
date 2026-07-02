<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.foodorder.model.OrderItem, java.math.BigDecimal" %>
<%
    request.setAttribute("pageTitle", "Order Confirmed — HotServe");
    String ctx = request.getContextPath();
    Object orderIdObj   = request.getAttribute("orderId");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
    BigDecimal orderTotal      = (BigDecimal) request.getAttribute("orderTotal");
    String deliveryAddress     = (String) request.getAttribute("deliveryAddress");
    String paymentMethod       = (String) request.getAttribute("paymentMethod");
    if (orderItems == null) orderItems = java.util.Collections.emptyList();
    if (orderTotal == null) orderTotal = BigDecimal.ZERO;

    String payLabel = "Cash on Delivery";
    if ("card".equals(paymentMethod))    payLabel = "Credit / Debit Card";
    else if ("ewallet".equals(paymentMethod)) payLabel = "E-Wallet";
%>
<jsp:include page="header.jsp" />

<style>
.oc-card { background:#fff; border:1px solid var(--color-border); border-radius:16px; padding:32px; max-width:640px; margin:0 auto; }
.oc-header { text-align:center; margin-bottom:28px; }
.oc-check { font-size:3.5rem; }
.oc-title { font-size:1.6rem; font-weight:800; color:var(--color-text); margin:8px 0 4px; }
.oc-sub { color:var(--color-text-muted); font-size:.9rem; }
.oc-section { margin-bottom:20px; }
.oc-section-label { font-size:.72rem; font-weight:700; text-transform:uppercase; letter-spacing:.08em; color:var(--color-text-muted); margin-bottom:10px; }
.oc-info-row { display:flex; justify-content:space-between; font-size:.88rem; padding:6px 0; border-bottom:1px solid var(--color-border); }
.oc-info-row:last-child { border-bottom:none; }
.oc-info-val { font-weight:600; color:var(--color-text); }
.oc-total { display:flex; justify-content:space-between; font-size:1rem; font-weight:800; color:var(--color-primary); padding-top:14px; margin-top:8px; border-top:2px solid var(--color-border); }
.oc-actions { display:flex; gap:12px; justify-content:center; margin-top:28px; }
</style>

<div class="container py-5">
  <div class="oc-card">
    <div class="oc-header">
      <div class="oc-check">✅</div>
      <div class="oc-title">Order Confirmed!</div>
      <div class="oc-sub">Thank you! Your order <strong>#<%= orderIdObj %></strong> has been placed successfully.</div>
    </div>

    <!-- Delivery info -->
    <div class="oc-section">
      <div class="oc-section-label">Delivery Details</div>
      <div class="oc-info-row">
        <span>Address</span>
        <span class="oc-info-val"><%= deliveryAddress != null ? deliveryAddress : "—" %></span>
      </div>
      <div class="oc-info-row">
        <span>Payment</span>
        <span class="oc-info-val"><%= payLabel %></span>
      </div>
    </div>

    <!-- Order items -->
    <div class="oc-section">
      <div class="oc-section-label">Order Summary</div>
      <% for (OrderItem item : orderItems) { %>
      <div class="oc-info-row">
        <span><%= item.getFoodName() %> × <%= item.getQuantity() %>
          <% if (item.getAddons() != null && !item.getAddons().isEmpty()) { %>
            <br><small style="color:var(--color-text-muted)"><%= item.getAddons() %></small>
          <% } %>
        </span>
        <span class="oc-info-val">RM <%= String.format("%,.2f", item.getSubtotal()) %></span>
      </div>
      <% } %>
      <div class="oc-total">
        <span>Total Paid</span>
        <span>RM <%= String.format("%,.2f", orderTotal) %></span>
      </div>
    </div>

    <div class="oc-actions">
      <a href="<%= ctx %>/menu" class="btn btn-brand">Order More</a>
      <a href="<%= ctx %>/index.jsp" class="btn btn-outline-brand">Back to Home</a>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
