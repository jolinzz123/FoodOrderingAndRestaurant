<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.dao.FoodDAO, com.foodorder.dao.CategoryDAO, com.foodorder.dao.OrderDAO" %>
<%@ page import="com.foodorder.model.Order, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Dashboard");
    request.setAttribute("activePage", "dashboard");
    FoodDAO foodDAO = new FoodDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    OrderDAO orderDAO = new OrderDAO();
    int foodCount = foodDAO.findAll().size();
    int catCount  = categoryDAO.findAll().size();
    List<Order> allOrders = orderDAO.findAll();
    int orderCount = allOrders.size();
    List<Order> latestOrders = allOrders.size() > 5 ? allOrders.subList(0, 5) : allOrders;
    String ctx = request.getContextPath();
%>
<jsp:include page="/admin/admin-header.jsp" />

<!-- Stat Cards -->
<div class="row g-4 mb-4">
  <div class="col-sm-4">
    <div class="adm-stat-card">
      <div class="adm-stat-icon" style="background:#EDE9FE; color:#7C6FE8;">
        <i class="bi bi-basket-fill"></i>
      </div>
      <div class="adm-stat-label">Products</div>
      <div class="adm-stat-number"><%= foodCount %></div>
      <a href="<%= ctx %>/admin/food" class="adm-stat-link">Manage &rarr;</a>
    </div>
  </div>
  <div class="col-sm-4">
    <div class="adm-stat-card">
      <div class="adm-stat-icon" style="background:#E8E5FD; color:#6558D4;">
        <i class="bi bi-collection-fill"></i>
      </div>
      <div class="adm-stat-label">Categories</div>
      <div class="adm-stat-number"><%= catCount %></div>
      <a href="<%= ctx %>/admin/category" class="adm-stat-link">Manage &rarr;</a>
    </div>
  </div>
  <div class="col-sm-4">
    <div class="adm-stat-card">
      <div class="adm-stat-icon" style="background:#F0EDFA; color:#5B21B6;">
        <i class="bi bi-receipt"></i>
      </div>
      <div class="adm-stat-label">Total Orders</div>
      <div class="adm-stat-number"><%= orderCount %></div>
      <a href="<%= ctx %>/admin/orders" class="adm-stat-link">View all &rarr;</a>
    </div>
  </div>
</div>

<!-- Quick Actions -->
<div class="adm-card mb-4">
  <div class="adm-card-title">Quick Actions</div>
  <div class="d-flex flex-wrap gap-2">
    <a href="<%= ctx %>/admin/food" class="btn btn-primary btn-sm">+ Add Product</a>
    <a href="<%= ctx %>/admin/category" class="btn btn-outline-brand btn-sm">+ Add Category</a>
    <a href="<%= ctx %>/admin/orders" class="btn btn-outline-brand btn-sm">View All Orders</a>
  </div>
</div>

<!-- Recent Orders -->
<div class="adm-card">
  <div class="adm-card-title">Recent Orders</div>
  <% if (latestOrders.isEmpty()) { %>
    <p class="text-muted mb-0">No orders have been placed yet.</p>
  <% } else { %>
  <div class="table-responsive">
    <table class="table table-hover table-brand align-middle mb-0">
      <thead>
        <tr>
          <th>Order #</th>
          <th>Customer</th>
          <th>Total</th>
          <th>Status</th>
          <th>Date &amp; Time</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <% for (Order o : latestOrders) { %>
        <tr>
          <td><strong>#<%= o.getId() %></strong></td>
          <td><%= o.getUsername() %></td>
          <td>RM&nbsp;<%= String.format("%.2f", o.getTotalPrice()) %></td>
          <td><span class="status-pill status-<%= o.getStatus() %>"><%= o.getStatus() %></span></td>
          <td style="font-size:0.85rem; color:#6B7280;">
            <%= o.getCreatedAt() != null ? o.getCreatedAt().toString().substring(0, 16) : "-" %>
          </td>
          <td>
            <a href="<%= ctx %>/admin/orders" class="btn btn-sm btn-outline-brand">Update</a>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  <% if (allOrders.size() > 5) { %>
    <div class="mt-3">
      <a href="<%= ctx %>/admin/orders" class="adm-stat-link">View all <%= orderCount %> orders &rarr;</a>
    </div>
  <% } %>
  <% } %>
</div>

<jsp:include page="/admin/admin-footer.jsp" />
