<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.Order, com.foodorder.model.OrderItem, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Customer Orders");
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<Order> orders = (List<Order>) request.getAttribute("orders");

    String[] statuses = {"PENDING", "CONFIRMED", "PREPARING", "COMPLETED", "CANCELLED"};
%>
<jsp:include page="/header.jsp" />

<div class="container-fluid px-0">
  <div class="row g-0">

    <!-- Sidebar -->
    <nav class="col-md-2 admin-sidebar">
      <div class="text-center mb-3 px-3" style="color:#A5D6A7; font-weight:700; font-size:0.8rem; letter-spacing:1px;">ADMIN PANEL</div>
      <a href="<%= ctx %>/admin/dashboard.jsp">&#x1F4CA; Dashboard</a>
      <a href="<%= ctx %>/admin/food">&#x1F37D; Manage Food</a>
      <a href="<%= ctx %>/admin/category">&#x1F3F7; Categories</a>
      <a href="<%= ctx %>/admin/orders" class="active">&#x1F4CB; Orders</a>
      <hr style="border-color:rgba(255,255,255,0.2); margin:12px 20px;">
      <a href="<%= ctx %>/index.jsp">&#x2190; Back to Site</a>
    </nav>

    <!-- Main Content -->
    <main class="col-md-10 p-4">
      <div class="d-flex align-items-center justify-content-between mb-4">
        <h3 class="mb-0">Customer Orders</h3>
        <span class="badge bg-secondary fs-6"><%= orders != null ? orders.size() : 0 %> total</span>
      </div>

      <% if (orders == null || orders.isEmpty()) { %>
        <div class="text-center py-5 text-muted">
          <div style="font-size:3rem;">&#x1F4CB;</div>
          <p class="mt-2">No customer orders yet.</p>
        </div>
      <% } else { %>

      <!-- Status filter legend -->
      <div class="d-flex flex-wrap gap-2 mb-4">
        <% for (String s : statuses) { %>
          <span class="status-pill status-<%= s %>"><%= s %></span>
        <% } %>
      </div>

      <div class="accordion" id="ordersAccordion">
        <% int idx = 0; for (Order o : orders) { idx++; %>
        <div class="accordion-item mb-3" style="border:1px solid var(--color-border); border-radius:var(--radius); overflow:hidden;">

          <!-- Order Header -->
          <h2 class="accordion-header">
            <button class="accordion-button <%= idx > 1 ? "collapsed" : "" %>"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#order<%= o.getId() %>"
                    aria-expanded="<%= idx == 1 ? "true" : "false" %>">
              <div class="d-flex w-100 align-items-center flex-wrap gap-3">
                <strong style="min-width:80px;">#<%= o.getId() %></strong>
                <span style="min-width:120px;">&#x1F464; <%= o.getUsername() %></span>
                <span class="fw-bold" style="min-width:90px;">RM&nbsp;<%= String.format("%.2f", o.getTotalPrice()) %></span>
                <span class="status-pill status-<%= o.getStatus() %>"><%= o.getStatus() %></span>
                <span class="text-muted ms-auto" style="font-size:0.82rem;">
                  <%= o.getCreatedAt() != null ? o.getCreatedAt().toString().substring(0, 16) : "-" %>
                </span>
              </div>
            </button>
          </h2>

          <!-- Order Details (collapse body) -->
          <div id="order<%= o.getId() %>" class="accordion-collapse collapse <%= idx == 1 ? "show" : "" %>">
            <div class="accordion-body p-4">

              <div class="row g-4">
                <!-- Order Items -->
                <div class="col-md-8">
                  <h6 class="mb-3" style="color:var(--color-primary-dark);">Order Items</h6>
                  <% List<OrderItem> items = o.getItems();
                     if (items == null || items.isEmpty()) { %>
                    <p class="text-muted">No items found.</p>
                  <% } else { %>
                  <table class="table table-sm table-brand">
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
                        <td style="font-size:0.82rem; color:var(--color-text-muted);">
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
                        <td class="text-end fw-bold" style="color:var(--color-primary-dark);">
                          RM&nbsp;<%= String.format("%.2f", o.getTotalPrice()) %>
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                  <% } %>
                </div>

                <!-- Order Info + Status Update -->
                <div class="col-md-4">
                  <h6 class="mb-3" style="color:var(--color-primary-dark);">Order Info</h6>
                  <div class="mb-2" style="font-size:0.88rem;">
                    <div class="text-muted">Order ID</div>
                    <div><strong>#<%= o.getId() %></strong></div>
                  </div>
                  <div class="mb-2" style="font-size:0.88rem;">
                    <div class="text-muted">Customer</div>
                    <div><strong><%= o.getUsername() %></strong> (User #<%= o.getUserId() %>)</div>
                  </div>
                  <div class="mb-2" style="font-size:0.88rem;">
                    <div class="text-muted">Placed at</div>
                    <div><%= o.getCreatedAt() != null ? o.getCreatedAt().toString().substring(0, 16) : "-" %></div>
                  </div>
                  <div class="mb-3" style="font-size:0.88rem;">
                    <div class="text-muted">Current Status</div>
                    <div><span class="status-pill status-<%= o.getStatus() %>"><%= o.getStatus() %></span></div>
                  </div>

                  <hr>
                  <h6 class="mb-2">Update Status</h6>
                  <form method="post" action="<%= ctx %>/admin/orders">
                    <input type="hidden" name="orderId" value="<%= o.getId() %>">
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
              </div><!-- /row -->

            </div><!-- /accordion-body -->
          </div><!-- /accordion-collapse -->
        </div><!-- /accordion-item -->
        <% } %>
      </div><!-- /accordion -->

      <% } %>
    </main>

  </div>
</div>

<jsp:include page="/footer.jsp" />
