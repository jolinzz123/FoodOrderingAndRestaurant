<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.dao.FoodDAO, com.foodorder.dao.CategoryDAO, com.foodorder.dao.OrderDAO" %>
<%@ page import="com.foodorder.model.Order, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Admin Dashboard");
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
<jsp:include page="/header.jsp" />

<div class="container-fluid px-0">
  <div class="row g-0">

    <!-- Sidebar -->
    <nav class="col-md-2 admin-sidebar">
      <div class="text-center mb-3 px-3" style="color:#A5D6A7; font-weight:700; font-size:0.8rem; letter-spacing:1px;">ADMIN PANEL</div>
      <a href="<%= ctx %>/admin/dashboard.jsp" class="active">&#x1F4CA; Dashboard</a>
      <a href="<%= ctx %>/admin/food">&#x1F37D; Manage Food</a>
      <a href="<%= ctx %>/admin/category">&#x1F3F7; Categories</a>
      <a href="<%= ctx %>/admin/orders">&#x1F4CB; Orders</a>
      <hr style="border-color:rgba(255,255,255,0.2); margin:12px 20px;">
      <a href="<%= ctx %>/index.jsp">&#x2190; Back to Site</a>
    </nav>

    <!-- Main Content -->
    <main class="col-md-10 p-4">
      <h3 class="mb-4">Dashboard Overview</h3>

      <!-- Stat Cards -->
      <div class="row g-4 mb-5">
        <div class="col-sm-4">
          <div class="admin-stat-card">
            <div class="text-muted mb-1" style="font-size:0.8rem; font-weight:600; letter-spacing:1px;">FOOD ITEMS</div>
            <div class="stat-number"><%= foodCount %></div>
            <a href="<%= ctx %>/admin/food" style="font-size:0.85rem;">Manage &rarr;</a>
          </div>
        </div>
        <div class="col-sm-4">
          <div class="admin-stat-card">
            <div class="text-muted mb-1" style="font-size:0.8rem; font-weight:600; letter-spacing:1px;">CATEGORIES</div>
            <div class="stat-number"><%= catCount %></div>
            <a href="<%= ctx %>/admin/category" style="font-size:0.85rem;">Manage &rarr;</a>
          </div>
        </div>
        <div class="col-sm-4">
          <div class="admin-stat-card">
            <div class="text-muted mb-1" style="font-size:0.8rem; font-weight:600; letter-spacing:1px;">TOTAL ORDERS</div>
            <div class="stat-number"><%= orderCount %></div>
            <a href="<%= ctx %>/admin/orders" style="font-size:0.85rem;">View all &rarr;</a>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="row g-3 mb-5">
        <div class="col-12">
          <h5 class="mb-3">Quick Actions</h5>
        </div>
        <div class="col-auto">
          <a href="<%= ctx %>/admin/food" class="btn btn-primary">+ Add Food Item</a>
        </div>
        <div class="col-auto">
          <a href="<%= ctx %>/admin/category" class="btn btn-outline-secondary">+ Add Category</a>
        </div>
        <div class="col-auto">
          <a href="<%= ctx %>/admin/orders" class="btn btn-outline-secondary">View All Orders</a>
        </div>
      </div>

      <!-- Recent Orders -->
      <h5 class="mb-3">Recent Orders</h5>
      <% if (latestOrders.isEmpty()) { %>
        <p class="text-muted">No orders have been placed yet.</p>
      <% } else { %>
      <div class="table-responsive">
        <table class="table table-hover table-brand align-middle">
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
              <td style="font-size:0.88rem; color:var(--color-text-muted);">
                <%= o.getCreatedAt() != null ? o.getCreatedAt().toString().substring(0, 16) : "-" %>
              </td>
              <td>
                <a href="<%= ctx %>/admin/orders" class="btn btn-sm btn-outline-secondary">Update</a>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
      <% if (allOrders.size() > 5) { %>
        <a href="<%= ctx %>/admin/orders" class="btn btn-primary btn-sm">View All <%= orderCount %> Orders &rarr;</a>
      <% } %>
      <% } %>
    </main>

  </div>
</div>

<jsp:include page="/footer.jsp" />
