<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.Order, com.foodorder.model.OrderItem, java.util.List, com.foodorder.util.WebUtil" %>
<%
    request.setAttribute("pageTitle", "Orders");
    request.setAttribute("activePage", "orders");
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String searchQuery = (String) request.getAttribute("searchQuery");

    Integer totalOrdersCount = (Integer) request.getAttribute("totalOrdersCount");
    Integer completedOrdersCount = (Integer) request.getAttribute("completedOrdersCount");
    Integer pendingOrdersCount = (Integer) request.getAttribute("pendingOrdersCount");
    Integer cancelledOrdersCount = (Integer) request.getAttribute("cancelledOrdersCount");

    String[] statuses = {"PENDING", "CONFIRMED", "PREPARING", "COMPLETED", "CANCELLED"};
%>
<jsp:include page="/admin/admin-header.jsp" />

<!-- Stat Cards -->
<div class="row g-4 mb-4">
  <div class="col-6 col-md-3">
    <div class="adm-stat-card">
      <div class="adm-stat-icon" style="background:#EDE9FE; color:#7C6FE8;">
        <i class="bi bi-receipt"></i>
      </div>
      <div class="adm-stat-label">Total Orders</div>
      <div class="adm-stat-number"><%= totalOrdersCount %></div>
    </div>
  </div>
  <div class="col-6 col-md-3">
    <div class="adm-stat-card">
      <div class="adm-stat-icon" style="background:#DCFCE7; color:#15803D;">
        <i class="bi bi-check-circle-fill"></i>
      </div>
      <div class="adm-stat-label">Completed Orders</div>
      <div class="adm-stat-number"><%= completedOrdersCount %></div>
    </div>
  </div>
  <div class="col-6 col-md-3">
    <div class="adm-stat-card">
      <div class="adm-stat-icon" style="background:#FFF3CD; color:#8A6D00;">
        <i class="bi bi-clock-fill"></i>
      </div>
      <div class="adm-stat-label">Pending Orders</div>
      <div class="adm-stat-number"><%= pendingOrdersCount %></div>
    </div>
  </div>
  <div class="col-6 col-md-3">
    <div class="adm-stat-card">
      <div class="adm-stat-icon" style="background:#FEE2E2; color:#B91C1C;">
        <i class="bi bi-slash-circle-fill"></i>
      </div>
      <div class="adm-stat-label">Canceled Orders</div>
      <div class="adm-stat-number"><%= cancelledOrdersCount %></div>
    </div>
  </div>
</div>

<!-- Status legend + Search -->
<div class="d-flex flex-wrap gap-2 mb-4 align-items-center">
  <span style="font-size:0.8rem; color:#6B7280; font-weight:600;">Status:</span>
  <% for (String s : statuses) { %>
    <span class="status-pill status-<%= s %>"><%= s %></span>
  <% } %>
  <form method="get" action="<%= ctx %>/admin/orders" class="d-flex ms-auto" style="max-width:280px; width:100%;">
    <div class="input-group input-group-sm">
      <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
      <input type="text" name="q" class="form-control" placeholder="Search by order #, customer, status..."
             value="<%= searchQuery != null ? WebUtil.escapeHtml(searchQuery) : "" %>">
      <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
        <a href="<%= ctx %>/admin/orders" class="btn btn-outline-secondary" title="Clear search"><i class="bi bi-x-lg"></i></a>
      <% } %>
    </div>
  </form>
  <span class="badge bg-secondary"><%= orders != null ? orders.size() : 0 %> orders</span>
</div>

<% if (orders == null || orders.isEmpty()) { %>
  <div class="adm-card text-center py-5">
    <div style="font-size:3rem;">📋</div>
    <p class="mt-2 text-muted mb-0">
      <%= (searchQuery != null && !searchQuery.isEmpty())
          ? "No orders match \"" + WebUtil.escapeHtml(searchQuery) + "\"."
          : "No customer orders yet." %>
    </p>
  </div>
<% } else { %>

<div class="accordion" id="ordersAccordion">
  <% int idx = 0; for (Order o : orders) { idx++; %>
  <div class="adm-card mb-3 p-0" style="overflow:hidden; border-radius:14px;">

    <div class="accordion-item border-0">
      <h2 class="accordion-header">
        <button class="accordion-button <%= idx > 1 ? "collapsed" : "" %>"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#order<%= o.getId() %>"
                aria-expanded="<%= idx == 1 ? "true" : "false" %>"
                style="border-radius:14px; background:#fff; box-shadow:none;">
          <div class="d-flex w-100 align-items-center flex-wrap gap-3">
            <strong style="min-width:70px; color:#111827;">#<%= o.getId() %></strong>
            <span style="min-width:120px; color:#374151;">&#x1F464; <%= o.getUsername() %></span>
            <span class="fw-bold" style="min-width:90px; color:#111827;">RM&nbsp;<%= String.format("%.2f", o.getTotalPrice()) %></span>
            <span class="status-pill status-<%= o.getStatus() %>"><%= o.getStatus() %></span>
            <span class="text-muted ms-auto" style="font-size:0.82rem;">
              <%= o.getCreatedAt() != null ? o.getCreatedAt().toString().substring(0, 16) : "-" %>
            </span>
          </div>
        </button>
      </h2>

      <div id="order<%= o.getId() %>" class="accordion-collapse collapse <%= idx == 1 ? "show" : "" %>">
        <div class="accordion-body p-4" style="background:#FAFAFA; border-top:1px solid #F3F4F6;">

          <div class="row g-4">
            <!-- Order Items -->
            <div class="col-md-8">
              <h6 class="mb-3" style="color:#111827; font-weight:700;">Order Items</h6>
              <% List<OrderItem> items = o.getItems();
                 if (items == null || items.isEmpty()) { %>
                <p class="text-muted">No items found.</p>
              <% } else { %>
              <table class="table table-sm table-brand mb-0">
                <thead>
                  <tr>
                    <th>Item</th>
                    <th>Add-ons</th>
                    <th class="text-center">Qty</th>
                    <th class="text-end">Subtotal</th>
                  </tr>
                </thead>
                <tbody>
                  <% for (OrderItem oi : items) { %>
                  <tr>
                    <td><%= oi.getFoodName() %></td>
                    <td style="font-size:0.82rem; color:#6B7280;">
                      <%= (oi.getAddons() != null && !oi.getAddons().isEmpty()) ? oi.getAddons() : "-" %>
                    </td>
                    <td class="text-center"><%= oi.getQuantity() %></td>
                    <td class="text-end">RM&nbsp;<%= String.format("%.2f", oi.getSubtotal()) %></td>
                  </tr>
                  <% } %>
                </tbody>
                <tfoot>
                  <tr>
                    <td colspan="3" class="text-end fw-bold">Total:</td>
                    <td class="text-end fw-bold" style="color:#2E7D32;">
                      RM&nbsp;<%= String.format("%.2f", o.getTotalPrice()) %>
                    </td>
                  </tr>
                </tfoot>
              </table>
              <% } %>
            </div>

            <!-- Order Info + Status Update -->
            <div class="col-md-4">
              <h6 class="mb-3" style="color:#111827; font-weight:700;">Order Info</h6>
              <div class="mb-2" style="font-size:0.87rem;">
                <div class="text-muted">Order ID</div>
                <div><strong>#<%= o.getId() %></strong></div>
              </div>
              <div class="mb-2" style="font-size:0.87rem;">
                <div class="text-muted">Customer</div>
                <div><strong><%= o.getUsername() %></strong> (User #<%= o.getUserId() %>)</div>
              </div>
              <div class="mb-2" style="font-size:0.87rem;">
                <div class="text-muted">Placed at</div>
                <div><%= o.getCreatedAt() != null ? o.getCreatedAt().toString().substring(0, 16) : "-" %></div>
              </div>
              <div class="mb-3" style="font-size:0.87rem;">
                <div class="text-muted">Current Status</div>
                <div><span class="status-pill status-<%= o.getStatus() %>"><%= o.getStatus() %></span></div>
              </div>

              <hr>
              <h6 class="mb-2" style="font-size:0.87rem; font-weight:700;">Update Status</h6>
              <form method="post" action="<%= ctx %>/admin/orders">
                <input type="hidden" name="orderId" value="<%= o.getId() %>">
                <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                  <input type="hidden" name="q" value="<%= WebUtil.escapeHtml(searchQuery) %>">
                <% } %>
                <div class="mb-2">
                  <select name="status" class="form-select form-select-sm">
                    <% for (String s : statuses) { %>
                      <option value="<%= s %>" <%= o.getStatus().equals(s) ? "selected" : "" %>><%= s %></option>
                    <% } %>
                  </select>
                </div>
                <button type="submit" class="btn btn-primary btn-sm w-100">Update Status</button>
              </form>
            </div>
          </div>

        </div>
      </div>
    </div>

  </div>
  <% } %>
</div>

<% } %>

<jsp:include page="/admin/admin-footer.jsp" />
