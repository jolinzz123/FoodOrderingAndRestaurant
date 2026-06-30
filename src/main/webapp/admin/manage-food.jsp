<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.FoodItem, com.foodorder.model.Category, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Manage Food Items");
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<FoodItem> foodItems = (List<FoodItem>) request.getAttribute("foodItems");

    @SuppressWarnings("unchecked")
    List<Category> categories = (List<Category>) request.getAttribute("categories");

    FoodItem editItem = (FoodItem) request.getAttribute("editItem");
    boolean isEdit = (editItem != null);
%>
<jsp:include page="/header.jsp" />

<div class="container-fluid px-0">
  <div class="row g-0">

    <!-- Sidebar -->
    <nav class="col-md-2 admin-sidebar">
      <div class="text-center mb-3 px-3" style="color:#A5D6A7; font-weight:700; font-size:0.8rem; letter-spacing:1px;">ADMIN PANEL</div>
      <a href="<%= ctx %>/admin/dashboard.jsp">&#x1F4CA; Dashboard</a>
      <a href="<%= ctx %>/admin/food" class="active">&#x1F37D; Manage Food</a>
      <a href="<%= ctx %>/admin/category">&#x1F3F7; Categories</a>
      <a href="<%= ctx %>/admin/orders">&#x1F4CB; Orders</a>
      <hr style="border-color:rgba(255,255,255,0.2); margin:12px 20px;">
      <a href="<%= ctx %>/index.jsp">&#x2190; Back to Site</a>
    </nav>

    <!-- Main Content -->
    <main class="col-md-10 p-4">
      <div class="d-flex align-items-center justify-content-between mb-4">
        <h3 class="mb-0"><%= isEdit ? "Edit Food Item" : "Manage Food Items" %></h3>
        <% if (isEdit) { %>
          <a href="<%= ctx %>/admin/food" class="btn btn-outline-secondary btn-sm">+ Add New Item</a>
        <% } %>
      </div>

      <!-- Add / Edit Form -->
      <div class="card mb-4" style="border:1px solid var(--color-border); border-radius:var(--radius);">
        <div class="card-body p-4">
          <h5 class="mb-3"><%= isEdit ? "Edit: " + editItem.getName() : "Add New Food Item" %></h5>
          <form method="post" action="<%= ctx %>/admin/food">
            <% if (isEdit) { %>
              <input type="hidden" name="action" value="update">
              <input type="hidden" name="id" value="<%= editItem.getId() %>">
            <% } %>

            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">Food Name <span class="text-danger">*</span></label>
                <input type="text" name="name" class="form-control" required
                       value="<%= isEdit ? editItem.getName() : "" %>">
              </div>
              <div class="col-md-6">
                <label class="form-label">Category <span class="text-danger">*</span></label>
                <select name="categoryId" class="form-select" required>
                  <option value="">-- Select Category --</option>
                  <% if (categories != null) { for (Category c : categories) { %>
                    <option value="<%= c.getId() %>"
                      <%= (isEdit && editItem.getCategoryId() == c.getId()) ? "selected" : "" %>>
                      <%= c.getName() %>
                    </option>
                  <% } } %>
                </select>
              </div>
              <div class="col-12">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="2"><%= isEdit && editItem.getDescription() != null ? editItem.getDescription() : "" %></textarea>
              </div>
              <div class="col-md-6">
                <label class="form-label">Ingredients</label>
                <textarea name="ingredients" class="form-control" rows="2"><%= isEdit && editItem.getIngredients() != null ? editItem.getIngredients() : "" %></textarea>
              </div>
              <div class="col-md-6">
                <label class="form-label">Nutritional Info</label>
                <textarea name="nutritionalInfo" class="form-control" rows="2"><%= isEdit && editItem.getNutritionalInfo() != null ? editItem.getNutritionalInfo() : "" %></textarea>
              </div>
              <div class="col-md-4">
                <label class="form-label">Price (RM) <span class="text-danger">*</span></label>
                <input type="number" name="price" class="form-control" step="0.01" min="0" required
                       value="<%= isEdit ? editItem.getPrice() : "" %>">
              </div>
              <div class="col-md-6">
                <label class="form-label">Image URL</label>
                <input type="text" name="imageUrl" class="form-control" placeholder="images/placeholder.jpg"
                       value="<%= isEdit && editItem.getImageUrl() != null ? editItem.getImageUrl() : "" %>">
              </div>
              <div class="col-md-2 d-flex align-items-end">
                <div class="form-check mb-2">
                  <input type="checkbox" name="available" id="available" class="form-check-input"
                         <%= (!isEdit || editItem.isAvailable()) ? "checked" : "" %>>
                  <label for="available" class="form-check-label">Available</label>
                </div>
              </div>
            </div>

            <div class="mt-3 d-flex gap-2">
              <button type="submit" class="btn btn-primary">
                <%= isEdit ? "Save Changes" : "Add Food Item" %>
              </button>
              <% if (isEdit) { %>
                <a href="<%= ctx %>/admin/food" class="btn btn-outline-secondary">Cancel</a>
              <% } %>
            </div>
          </form>
        </div>
      </div>

      <!-- Food Items Table -->
      <h5 class="mb-3">All Food Items (<%= foodItems != null ? foodItems.size() : 0 %>)</h5>
      <% if (foodItems == null || foodItems.isEmpty()) { %>
        <p class="text-muted">No food items found. Add one above.</p>
      <% } else { %>
      <div class="table-responsive">
        <table class="table table-hover table-brand align-middle">
          <thead>
            <tr>
              <th>#</th>
              <th>Name</th>
              <th>Category</th>
              <th>Price</th>
              <th>Rating</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <% for (FoodItem f : foodItems) { %>
            <tr>
              <td><%= f.getId() %></td>
              <td>
                <strong><%= f.getName() %></strong>
                <% if (f.getDescription() != null && !f.getDescription().isEmpty()) { %>
                  <div style="font-size:0.8rem; color:var(--color-text-muted);">
                    <%= f.getDescription().length() > 50 ? f.getDescription().substring(0, 50) + "…" : f.getDescription() %>
                  </div>
                <% } %>
              </td>
              <td><span class="badge-category"><%= f.getCategoryName() != null ? f.getCategoryName() : "-" %></span></td>
              <td><strong>RM <%= String.format("%.2f", f.getPrice()) %></strong></td>
              <td><span class="badge-rating">&#x2605; <%= String.format("%.1f", f.getRating()) %></span></td>
              <td>
                <% if (f.isAvailable()) { %>
                  <span class="status-pill status-CONFIRMED">Available</span>
                <% } else { %>
                  <span class="status-pill status-CANCELLED">Unavailable</span>
                <% } %>
              </td>
              <td>
                <a href="<%= ctx %>/admin/food?action=edit&id=<%= f.getId() %>"
                   class="btn btn-sm btn-outline-secondary me-1">Edit</a>
                <a href="<%= ctx %>/admin/food?action=delete&id=<%= f.getId() %>"
                   class="btn btn-sm btn-outline-danger"
                   onclick="return confirm('Delete \'<%= f.getName() %>\'?')">Delete</a>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
      <% } %>
    </main>

  </div>
</div>

<jsp:include page="/footer.jsp" />
