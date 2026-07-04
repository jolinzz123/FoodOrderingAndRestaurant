<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.FoodItem, com.foodorder.model.Category, com.foodorder.model.Addon, java.util.List, java.math.BigDecimal, com.foodorder.util.WebUtil" %>
<%
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<FoodItem> foodItems = (List<FoodItem>) request.getAttribute("foodItems");

    @SuppressWarnings("unchecked")
    List<Category> categories = (List<Category>) request.getAttribute("categories");

    @SuppressWarnings("unchecked")
    List<Addon> productAddons = (List<Addon>) request.getAttribute("productAddons");

    Addon editAddon = (Addon) request.getAttribute("editAddon");
    boolean isEditAddon = (editAddon != null);

    FoodItem editItem = (FoodItem) request.getAttribute("editItem");
    boolean isEdit = (editItem != null);
    String searchQuery = (String) request.getAttribute("searchQuery");
    String categoryFilterName = (String) request.getAttribute("categoryFilterName");
    String categoryFilterId = (String) request.getAttribute("categoryFilterId");
    String sort = (String) request.getAttribute("sort");
    if (sort == null) sort = "";

    request.setAttribute("pageTitle", isEdit ? "Edit Product" : "Products");
    request.setAttribute("activePage", "food");
%>
<jsp:include page="/admin/admin-header.jsp" />

<!-- Add / Edit Form -->
<div class="adm-card mb-4">
  <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">

    <div class="adm-card-title mb-0"><%= isEdit ? "Edit: " + editItem.getName() : "Add New Product" %></div>

    <% if (isEdit) { %>
      <a href="<%= ctx %>/admin/food" class="btn btn-outline-brand btn-sm text-nowrap">+ Add New Item</a>
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

    <% if (!isEdit) { %>
    <div class="mt-3">
      <label class="form-label d-block">Add-ons (optional)</label>
      <div id="newAddonRows">
        <div class="row g-2 align-items-end mb-2 new-addon-row">
          <div class="col-md-6">
            <input type="text" name="addonNames" class="form-control form-control-sm" placeholder="e.g. Extra Cheese">
          </div>
          <div class="col-md-4">
            <input type="number" name="addonPrices" class="form-control form-control-sm" step="0.01" min="0" placeholder="Extra price (RM)">
          </div>
          <div class="col-md-2">
            <button type="button" class="btn btn-outline-secondary btn-sm w-100 remove-addon-row">Remove</button>
          </div>
        </div>
      </div>
      <button type="button" id="addAddonRowBtn" class="btn btn-outline-brand btn-sm">+ Add another add-on</button>
    </div>
    <% } %>

    <div class="mt-3 d-flex gap-2 adm-form-actions">
      <button type="submit" class="btn btn-primary flex-grow-1 text-nowrap">
        <%= isEdit ? "Save Changes" : "Add Product" %>
      </button>
      <% if (isEdit) { %>
        <a href="<%= ctx %>/admin/food" class="btn btn-outline-brand text-nowrap">Cancel</a>
      <% } %>
    </div>
  </form>
</div>

<% if (!isEdit) { %>
<script>
(function () {
  var container = document.getElementById('newAddonRows');
  var addBtn = document.getElementById('addAddonRowBtn');
  if (!container || !addBtn) return;

  function rowTemplate() {
    var row = document.createElement('div');
    row.className = 'row g-2 align-items-end mb-2 new-addon-row';
    row.innerHTML =
      '<div class="col-md-6">' +
        '<input type="text" name="addonNames" class="form-control form-control-sm" placeholder="e.g. Extra Cheese">' +
      '</div>' +
      '<div class="col-md-4">' +
        '<input type="number" name="addonPrices" class="form-control form-control-sm" step="0.01" min="0" placeholder="Extra price (RM)">' +
      '</div>' +
      '<div class="col-md-2">' +
        '<button type="button" class="btn btn-outline-secondary btn-sm w-100 remove-addon-row">Remove</button>' +
      '</div>';
    return row;
  }

  addBtn.addEventListener('click', function () {
    container.appendChild(rowTemplate());
  });

  container.addEventListener('click', function (e) {
    var btn = e.target.closest('.remove-addon-row');
    if (!btn) return;
    btn.closest('.new-addon-row').remove();
  });
})();
</script>
<% } %>

<% if (isEdit) { %>
<!-- Add-ons for this product -->
<div class="adm-card mb-4">
  <div class="adm-card-title">Add-ons for "<%= WebUtil.escapeHtml(editItem.getName()) %>"</div>

  <% if (productAddons == null || productAddons.isEmpty()) { %>
    <p class="text-muted" style="font-size:0.85rem;">No add-ons yet for this product.</p>
  <% } else { %>
    <div class="d-flex flex-wrap gap-2 mb-3">
      <% for (Addon a : productAddons) { %>
        <span class="adm-addon-chip <%= (isEditAddon && editAddon.getId() == a.getId()) ? "adm-addon-chip-active" : "" %>">
          <%= WebUtil.escapeHtml(a.getName()) %>
          <% if (a.getExtraPrice() != null && a.getExtraPrice().compareTo(BigDecimal.ZERO) > 0) { %>
            <span class="adm-addon-price">+RM <%= String.format("%.2f", a.getExtraPrice()) %></span>
          <% } %>
          <a href="<%= ctx %>/admin/food?action=edit&id=<%= editItem.getId() %>&editAddonId=<%= a.getId() %>"
             class="adm-addon-edit" title="Edit add-on">
            <i class="bi bi-pencil-fill"></i>
          </a>
          <a href="<%= ctx %>/admin/addon?action=delete&id=<%= a.getId() %>&foodItemId=<%= editItem.getId() %>"
             class="adm-addon-delete" title="Remove add-on" onclick="return confirm('Remove add-on \'<%= a.getName() %>\'?')">
            <i class="bi bi-x-lg"></i>
          </a>
        </span>
      <% } %>
    </div>
  <% } %>

  <form method="post" action="<%= ctx %>/admin/addon" class="row g-2 align-items-end">
    <input type="hidden" name="foodItemId" value="<%= editItem.getId() %>">
    <% if (isEditAddon) { %>
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="id" value="<%= editAddon.getId() %>">
    <% } %>
    <div class="col-md-6">
      <label class="form-label">Add-on Name</label>
      <input type="text" name="name" class="form-control form-control-sm" placeholder="e.g. Extra Cheese" required
             value="<%= isEditAddon ? WebUtil.escapeHtml(editAddon.getName()) : "" %>">
    </div>
    <div class="col-md-3">
      <label class="form-label">Extra Price (RM)</label>
      <input type="number" name="extraPrice" class="form-control form-control-sm" step="0.01" min="0" placeholder="0.00"
             value="<%= isEditAddon && editAddon.getExtraPrice() != null ? editAddon.getExtraPrice() : "" %>">
    </div>
    <div class="col-md-3 d-flex gap-2">
      <button type="submit" class="btn btn-outline-brand btn-sm flex-grow-1"><%= isEditAddon ? "Update" : "+ Add" %></button>
      <% if (isEditAddon) { %>
        <a href="<%= ctx %>/admin/food?action=edit&id=<%= editItem.getId() %>" class="btn btn-outline-secondary btn-sm">Cancel</a>
      <% } %>
    </div>
  </form>
</div>
<% } %>

<!-- Food Items Grid -->
<div class="adm-card">
  <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
    <div class="adm-card-title mb-0 d-flex align-items-center flex-wrap gap-2">
      All Products
      <% if (categoryFilterName != null) { %>
        <span class="adm-filter-chip">
          <%= WebUtil.escapeHtml(categoryFilterName) %>
          <a href="<%= ctx %>/admin/food" title="Clear filter"><i class="bi bi-x-lg"></i></a>
        </span>
      <% } %>
    </div>
    <div class="d-flex align-items-center flex-wrap gap-2 adm-list-toolbar-right">
      <form method="get" action="<%= ctx %>/admin/food" class="d-flex flex-wrap align-items-center gap-2 flex-grow-1">
        <% if (categoryFilterId != null) { %>
          <input type="hidden" name="categoryId" value="<%= categoryFilterId %>">
        <% } %>
        <div class="input-group input-group-sm adm-toolbar-search">
          <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
          <input type="text" name="q" class="form-control" placeholder="Search by name or category..."
                 value="<%= searchQuery != null ? WebUtil.escapeHtml(searchQuery) : "" %>">
          <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
            <a href="<%= ctx %>/admin/food" class="btn btn-outline-secondary" title="Clear search"><i class="bi bi-x-lg"></i></a>
          <% } %>
        </div>
        <%
          String priceNextSort, priceSortIcon, priceSortTitle;
          if ("price_asc".equals(sort)) {
            priceNextSort = "price_desc"; priceSortIcon = "bi-sort-numeric-down"; priceSortTitle = "Sorted: Price Low to High (click for High to Low)";
          } else if ("price_desc".equals(sort)) {
            priceNextSort = ""; priceSortIcon = "bi-sort-numeric-up"; priceSortTitle = "Sorted: Price High to Low (click to reset)";
          } else {
            priceNextSort = "price_asc"; priceSortIcon = "bi-arrow-down-up"; priceSortTitle = "Sort by price";
          }
        %>
        <button type="submit" name="sort" value="<%= priceNextSort %>"
                class="btn adm-sort-toggle-btn <%= sort.isEmpty() ? "" : "adm-sort-active" %>" title="<%= priceSortTitle %>">
          <i class="bi <%= priceSortIcon %>"></i>
        </button>
        <span class="badge bg-secondary text-nowrap"><%= foodItems != null ? foodItems.size() : 0 %> total</span>
      </form>
    </div>
  </div>

  <% if (foodItems == null || foodItems.isEmpty()) { %>
    <p class="text-muted">
      <%= (searchQuery != null && !searchQuery.isEmpty())
          ? "No products match \"" + WebUtil.escapeHtml(searchQuery) + "\"."
          : (categoryFilterName != null)
              ? "No products in \"" + WebUtil.escapeHtml(categoryFilterName) + "\" yet."
              : "No products found. Add one above." %>
    </p>
  <% } else { %>
  <div class="row g-3">
    <% for (FoodItem f : foodItems) { %>
    <div class="col-lg-3 col-md-4 col-sm-6">
      <div class="food-card adm-food-card adm-row-clickable" data-modal-target="#foodDetailModal<%= f.getId() %>">
        <div class="food-card-img-wrap">
          <img src="<%= ctx %>/<%= f.getImageUrl() %>" alt="<%= f.getName() %>"
               onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=70'">
          <% if (f.getCategoryName() != null) { %>
            <a href="<%= ctx %>/admin/food?categoryId=<%= f.getCategoryId() %>"
               class="badge-category adm-food-card-cat" title="View all <%= f.getCategoryName() %> items"><%= f.getCategoryName() %></a>
          <% } else { %>
            <span class="badge-category adm-food-card-cat" title="No category assigned">Uncategorized</span>
          <% } %>
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

      <!-- Detail Modal -->
      <div class="modal fade" id="foodDetailModal<%= f.getId() %>" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title"><span class="adm-food-card-id">#<%= f.getId() %></span> <%= f.getName() %></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              <div class="row g-4">
                <div class="col-md-5">
                  <img src="<%= ctx %>/<%= f.getImageUrl() %>" alt="<%= f.getName() %>" class="img-fluid rounded"
                       onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=70'">
                </div>
                <div class="col-md-7">
                  <div class="d-flex align-items-center gap-2 mb-3">
                    <span class="badge-category"><%= f.getCategoryName() != null ? f.getCategoryName() : "Uncategorized" %></span>
                    <span class="badge-rating">&#x2605; <%= String.format("%.1f", f.getRating()) %></span>
                    <% if (f.isAvailable()) { %>
                      <span class="status-pill status-CONFIRMED">Available</span>
                    <% } else { %>
                      <span class="status-pill status-CANCELLED">Unavailable</span>
                    <% } %>
                  </div>
                  <% if (f.getDescription() != null && !f.getDescription().isEmpty()) { %>
                    <p><strong>Description:</strong> <%= f.getDescription() %></p>
                  <% } %>
                  <% if (f.getIngredients() != null && !f.getIngredients().isEmpty()) { %>
                    <p><strong>Ingredients:</strong> <%= f.getIngredients() %></p>
                  <% } %>
                  <% if (f.getNutritionalInfo() != null && !f.getNutritionalInfo().isEmpty()) { %>
                    <p class="mb-0"><strong>Nutritional Info:</strong> <%= f.getNutritionalInfo() %></p>
                  <% } %>
                </div>
              </div>
            </div>
            <div class="modal-footer">
              <span class="food-card-price me-auto">RM <%= String.format("%.2f", f.getPrice()) %></span>
              <button type="button" class="btn btn-outline-brand btn-sm" data-bs-dismiss="modal">Close</button>
              <a href="<%= ctx %>/admin/food?action=delete&id=<%= f.getId() %>"
                 class="btn btn-danger-brand btn-sm" title="Delete"
                 onclick="return confirm('Delete \'<%= f.getName() %>\'?')">
                <i class="bi bi-trash-fill"></i> Delete
              </a>
              <a href="<%= ctx %>/admin/food?action=edit&id=<%= f.getId() %>" class="btn btn-primary btn-sm">Edit</a>
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
