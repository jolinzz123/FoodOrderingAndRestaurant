<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.FoodItem, com.foodorder.model.Category, java.util.List, com.foodorder.util.WebUtil" %>
<%
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<FoodItem> foodItems = (List<FoodItem>) request.getAttribute("foodItems");

    @SuppressWarnings("unchecked")
    List<Category> categories = (List<Category>) request.getAttribute("categories");

    FoodItem editItem = (FoodItem) request.getAttribute("editItem");
    boolean isEdit = (editItem != null);
    String searchQuery = (String) request.getAttribute("searchQuery");

    request.setAttribute("pageTitle", isEdit ? "Edit Product" : "Products");
    request.setAttribute("activePage", "food");
%>
<jsp:include page="/admin/admin-header.jsp" />

<!-- Add / Edit Form -->
<div class="adm-card mb-4">
  <div class="d-flex align-items-center justify-content-between mb-3">

    <div class="adm-card-title mb-0"><%= isEdit ? "Edit: " + editItem.getName() : "Add New Product" %></div>

    <% if (isEdit) { %>
      <a href="<%= ctx %>/admin/food" class="btn btn-outline-secondary btn-sm">+ Add New Item</a>
    <% } %>
  </div>

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

        <%= isEdit ? "Save Changes" : "Add Product" %>
      </button>
      <% if (isEdit) { %>
        <a href="<%= ctx %>/admin/food" class="btn btn-outline-secondary">Cancel</a>
      <% } %>
    </div>
  </form>
</div>

<!-- Food Items Grid -->
<div class="adm-card">
  <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
    <div class="adm-card-title mb-0">All Products</div>
    <form method="get" action="<%= ctx %>/admin/food" class="d-flex" style="max-width:300px; width:100%;">
      <div class="input-group input-group-sm">
        <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
        <input type="text" name="q" class="form-control" placeholder="Search by name or category..."
               value="<%= searchQuery != null ? WebUtil.escapeHtml(searchQuery) : "" %>">
        <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
          <a href="<%= ctx %>/admin/food" class="btn btn-outline-secondary" title="Clear search"><i class="bi bi-x-lg"></i></a>
        <% } %>
      </div>
    </form>
    <span class="badge bg-secondary"><%= foodItems != null ? foodItems.size() : 0 %> total</span>
  </div>

  <% if (foodItems == null || foodItems.isEmpty()) { %>
    <p class="text-muted">
      <%= (searchQuery != null && !searchQuery.isEmpty())
          ? "No products match \"" + WebUtil.escapeHtml(searchQuery) + "\"."
          : "No products found. Add one above." %>
    </p>
  <% } else { %>
  <div class="row g-3">
    <% for (FoodItem f : foodItems) { %>
    <div class="col-lg-3 col-md-4 col-sm-6">
      <div class="food-card adm-food-card">
        <div class="food-card-img-wrap">
          <img src="<%= ctx %>/<%= f.getImageUrl() %>" alt="<%= f.getName() %>"
               onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=70'">
          <span class="badge-category adm-food-card-cat"><%= f.getCategoryName() != null ? f.getCategoryName() : "-" %></span>
        </div>
        <div class="food-card-body">
          <div class="food-card-name"><span class="adm-food-card-id">#<%= f.getId() %></span> <%= f.getName() %></div>
          <% if (f.getDescription() != null && !f.getDescription().isEmpty()) { %>
            <div class="adm-food-card-desc">
              <%= f.getDescription().length() > 60 ? f.getDescription().substring(0, 60) + "…" : f.getDescription() %>
            </div>
          <% } %>
          <div class="food-card-meta d-flex align-items-center gap-2">
            <span class="badge-rating">&#x2605; <%= String.format("%.1f", f.getRating()) %></span>

            <% if (f.isAvailable()) { %>
              <span class="status-pill status-CONFIRMED">Available</span>
            <% } else { %>
              <span class="status-pill status-CANCELLED">Unavailable</span>
            <% } %>
          </div>
          <div class="food-card-footer">
            <span class="food-card-price">RM <%= String.format("%.2f", f.getPrice()) %></span>
            <div class="d-flex gap-1 flex-nowrap">
              <a href="<%= ctx %>/admin/food?action=edit&id=<%= f.getId() %>"
                 class="btn btn-sm btn-icon-edit" title="Edit">
                <i class="bi bi-pencil-fill"></i>
              </a>
              <a href="<%= ctx %>/admin/food?action=delete&id=<%= f.getId() %>"
                 class="btn btn-sm btn-icon-delete" title="Delete"
                 onclick="return confirm('Delete \'<%= f.getName() %>\'?')">
                <i class="bi bi-trash-fill"></i>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <% } %>
  </div>
  <% } %>
</div>

<jsp:include page="/admin/admin-footer.jsp" />
