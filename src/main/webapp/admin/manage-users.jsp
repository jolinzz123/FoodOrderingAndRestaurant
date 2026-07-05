<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.User, com.foodorder.model.Order, com.foodorder.model.OrderItem, java.util.List, com.foodorder.util.WebUtil" %>
<%
    request.setAttribute("pageTitle", "Users");
    request.setAttribute("activePage", "users");
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<User> users = (List<User>) request.getAttribute("users");
    String searchQuery = (String) request.getAttribute("searchQuery");

    User viewOrdersUser = (User) request.getAttribute("viewOrdersUser");
    @SuppressWarnings("unchecked")
    List<Order> viewOrdersList = (List<Order>) request.getAttribute("viewOrdersList");

    User currentUser = (User) session.getAttribute("user");
%>
<jsp:include page="/admin/admin-header.jsp" />

<% if (viewOrdersUser != null) { %>
<div class="adm-card mb-4">
  <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
    <div class="adm-card-title mb-0">Orders by <%= WebUtil.escapeHtml(viewOrdersUser.getUsername()) %></div>
    <a href="<%= ctx %>/admin/users" class="btn btn-outline-brand btn-sm text-nowrap">Close</a>
  </div>
  <% if (viewOrdersList == null || viewOrdersList.isEmpty()) { %>
    <p class="text-muted mb-0">This user hasn't placed any orders yet.</p>
  <% } else { %>
    <div class="table-responsive">
      <table class="table table-hover table-brand align-middle mb-0">
        <thead>
          <tr>
            <th>Order #</th>
            <th>Items</th>
            <th>Total</th>
            <th>Status</th>
            <th>Placed At</th>
          </tr>
        </thead>
        <tbody>
          <% for (Order o : viewOrdersList) { %>
          <tr>
            <td><strong>#<%= o.getId() %></strong></td>
            <td style="font-size:0.85rem; color:#6B7280;">
              <% List<OrderItem> items = o.getItems();
                 if (items != null && !items.isEmpty()) {
                   StringBuilder sb = new StringBuilder();
                   for (OrderItem oi : items) {
                     if (sb.length() > 0) sb.append(", ");
                     sb.append(oi.getFoodName()).append(" x").append(oi.getQuantity());
                   }
              %><%= sb.toString() %><% } else { %>-<% } %>
            </td>
            <td class="text-nowrap">RM <%= String.format("%.2f", o.getTotalPrice()) %></td>
            <td><span class="status-pill status-<%= o.getStatus() %>"><%= o.getStatus() %></span></td>
            <td style="font-size:0.85rem; color:#6B7280;" class="text-nowrap">
              <%= o.getCreatedAt() != null ? o.getCreatedAt().toString().substring(0, 16) : "-" %>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  <% } %>
</div>
<% } %>

<div class="adm-card">
  <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
    <div class="adm-card-title mb-0">All Users</div>
    <div class="d-flex align-items-center flex-wrap gap-2 adm-list-toolbar-right">
      <form method="get" action="<%= ctx %>/admin/users" class="d-flex flex-wrap align-items-center gap-2 flex-grow-1">
        <div class="input-group input-group-sm adm-toolbar-search">
          <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
          <input type="text" name="q" class="form-control" placeholder="Search by username or email..."
                 value="<%= searchQuery != null ? WebUtil.escapeHtml(searchQuery) : "" %>">
          <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
            <a href="<%= ctx %>/admin/users" class="btn btn-outline-secondary" title="Clear search"><i class="bi bi-x-lg"></i></a>
          <% } %>
        </div>
      </form>
      <span class="badge bg-secondary text-nowrap"><%= users != null ? users.size() : 0 %> total</span>
    </div>
  </div>

  <% if (users == null || users.isEmpty()) { %>
    <p class="text-muted">
      <%= (searchQuery != null && !searchQuery.isEmpty())
          ? "No users match \"" + WebUtil.escapeHtml(searchQuery) + "\"."
          : "No registered users yet." %>
    </p>
  <% } else { %>
  <div class="table-responsive">
    <table class="table table-hover table-brand align-middle mb-0">
      <thead>
        <tr>
          <th>#</th>
          <th>Username</th>
          <th class="d-none d-md-table-cell">Email</th>
          <th class="d-none d-lg-table-cell">Phone</th>
          <th>Role</th>
          <th class="d-none d-lg-table-cell">Registered</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <% int rowNum = 0; for (User u : users) { rowNum++; %>
        <tr>
          <td><%= rowNum %></td>
          <td>
            <strong><%= WebUtil.escapeHtml(u.getUsername()) %></strong>
            <div class="d-md-none" style="font-size:0.78rem; color:#6B7280;"><%= WebUtil.escapeHtml(u.getEmail()) %></div>
          </td>
          <td class="d-none d-md-table-cell"><%= WebUtil.escapeHtml(u.getEmail()) %></td>
          <td class="d-none d-lg-table-cell"><%= u.getPhone() != null ? WebUtil.escapeHtml(u.getPhone()) : "-" %></td>
          <td>
            <% if (u.isAdmin()) { %>
              <span class="status-pill status-CONFIRMED">ADMIN</span>
            <% } else { %>
              <span class="badge-category">CUSTOMER</span>
            <% } %>
          </td>
          <td class="d-none d-lg-table-cell text-nowrap" style="font-size:0.85rem; color:#6B7280;">
            <%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0, 10) : "-" %>
          </td>
          <td>
            <div class="d-flex gap-1 flex-nowrap">
              <a href="<%= ctx %>/admin/users?viewOrdersId=<%= u.getId() %>&viewOrdersType=<%= u.isAdmin() ? "admin" : "customer" %>" class="btn btn-sm btn-icon-edit" title="View Orders">
                <i class="bi bi-receipt"></i>
              </a>
              <% if (currentUser != null && currentUser.getId() == u.getId() && currentUser.isAdmin() == u.isAdmin()) { %>
                <span class="btn btn-sm btn-icon-disabled" title="You can't change your own role">
                  <i class="bi bi-person-fill"></i>
                </span>
              <% } else if (u.isAdmin()) { %>
                <a href="<%= ctx %>/admin/users?action=demote&id=<%= u.getId() %>" class="btn btn-sm btn-icon-delete" title="Demote to Customer"
                   onclick="return confirm('Demote \'<%= u.getUsername() %>\' to a regular customer?')">
                  <i class="bi bi-arrow-down-circle-fill"></i>
                </a>
              <% } else { %>
                <a href="<%= ctx %>/admin/users?action=promote&id=<%= u.getId() %>" class="btn btn-sm btn-icon-edit" title="Promote to Admin"
                   onclick="return confirm('Promote \'<%= u.getUsername() %>\' to admin?')">
                  <i class="bi bi-arrow-up-circle-fill"></i>
                </a>
              <% } %>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  <% } %>
</div>

<jsp:include page="/admin/admin-footer.jsp" />
