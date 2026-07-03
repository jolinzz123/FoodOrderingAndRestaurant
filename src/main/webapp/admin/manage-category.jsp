<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.Category, java.util.List, com.foodorder.util.WebUtil" %>
<%
    request.setAttribute("pageTitle", "Categories");
    request.setAttribute("activePage", "category");
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String sort = (String) request.getAttribute("sort");
    if (sort == null) sort = "";

    Category editItem = (Category) request.getAttribute("editItem");
    boolean isEdit = (editItem != null);
%>
<jsp:include page="/admin/admin-header.jsp" />

<div class="row g-4">
  <!-- Add / Edit Category Form -->
  <div class="col-lg-4">
    <div class="adm-card h-100">
      <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
        <div class="adm-card-title mb-0"><%= isEdit ? "Edit: " + editItem.getName() : "Add New Category" %></div>
        <% if (isEdit) { %>
          <a href="<%= ctx %>/admin/category" class="btn btn-outline-brand btn-sm text-nowrap">+ Add New</a>
        <% } %>
      </div>
      <form method="post" action="<%= ctx %>/admin/category">
        <% if (isEdit) { %>
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="id" value="<%= editItem.getId() %>">
        <% } %>
        <div class="mb-3">
          <label class="form-label">Category Name <span class="text-danger">*</span></label>
          <input type="text" name="name" class="form-control" placeholder="e.g. Drinks, Meals, Desserts" required
                 value="<%= isEdit ? WebUtil.escapeHtml(editItem.getName()) : "" %>">
        </div>
        <div class="d-flex gap-2 adm-form-actions">
          <button type="submit" class="btn btn-primary flex-grow-1 text-nowrap"><%= isEdit ? "Save Changes" : "Add Category" %></button>
          <% if (isEdit) { %>
            <a href="<%= ctx %>/admin/category" class="btn btn-outline-brand text-nowrap">Cancel</a>
          <% } %>
        </div>
      </form>

      <hr class="my-3">
      <p class="text-muted mb-0" style="font-size:0.83rem;">
        Deleting a category will not delete food items in that category,
        but they will lose their category assignment.
      </p>
    </div>
  </div>

  <!-- Categories Table -->
  <div class="col-lg-8">
    <div class="adm-card">
      <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
        <div class="adm-card-title mb-0">All Categories</div>
        <div class="d-flex align-items-center flex-wrap gap-2 adm-list-toolbar-right">
          <form method="get" action="<%= ctx %>/admin/category" class="d-flex flex-wrap align-items-center gap-2 flex-grow-1">
            <div class="input-group input-group-sm adm-toolbar-search">
              <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
              <input type="text" name="q" class="form-control" placeholder="Search categories..."
                     value="<%= searchQuery != null ? WebUtil.escapeHtml(searchQuery) : "" %>">
              <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                <a href="<%= ctx %>/admin/category" class="btn btn-outline-secondary" title="Clear search"><i class="bi bi-x-lg"></i></a>
              <% } %>
            </div>
            <%
              String nameNextSort, nameSortIcon, nameSortTitle;
              if ("name_asc".equals(sort)) {
                nameNextSort = "name_desc"; nameSortIcon = "bi-sort-alpha-down"; nameSortTitle = "Sorted: Name A to Z (click for Z to A)";
              } else if ("name_desc".equals(sort)) {
                nameNextSort = ""; nameSortIcon = "bi-sort-alpha-up"; nameSortTitle = "Sorted: Name Z to A (click to reset)";
              } else {
                nameNextSort = "name_asc"; nameSortIcon = "bi-arrow-down-up"; nameSortTitle = "Sort by name";
              }
            %>
            <button type="submit" name="sort" value="<%= nameNextSort %>"
                    class="btn btn-sm <%= sort.isEmpty() ? "btn-outline-brand" : "btn-brand-active" %>" title="<%= nameSortTitle %>">
              <i class="bi <%= nameSortIcon %>"></i>
            </button>
          </form>
          <span class="badge bg-secondary text-nowrap"><%= categories != null ? categories.size() : 0 %> total</span>
        </div>
      </div>

      <% if (categories == null || categories.isEmpty()) { %>

        <p class="text-muted">
          <%= (searchQuery != null && !searchQuery.isEmpty())
              ? "No categories match \"" + WebUtil.escapeHtml(searchQuery) + "\"."
              : "No categories yet. Add one to get started." %>
        </p>
      <% } else { %>
      <div class="table-responsive">
        <table class="table table-hover table-brand align-middle mb-0">
          <thead>
            <tr>
              <th>#</th>
              <th>Category Name</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <% int rowNum = 0; for (Category c : categories) { rowNum++; %>
            <tr class="adm-row-clickable" data-href="<%= ctx %>/admin/food?categoryId=<%= c.getId() %>">
              <td><%= rowNum %></td>
              <td>
                <a href="<%= ctx %>/admin/food?categoryId=<%= c.getId() %>"
                   class="badge-category fs-6 px-3 py-2" title="View products in <%= c.getName() %>"><%= c.getName() %></a>
              </td>
              <td>
                <div class="d-flex gap-1 flex-nowrap">
                  <a href="<%= ctx %>/admin/category?action=edit&id=<%= c.getId() %>"
                     class="btn btn-sm btn-icon-edit" title="Edit">
                    <i class="bi bi-pencil-fill"></i>
                  </a>
                  <a href="<%= ctx %>/admin/category?action=delete&id=<%= c.getId() %>"
                     class="btn btn-sm btn-icon-delete" title="Delete"
                     onclick="return confirm('Delete category \'<%= c.getName() %>\'?')">
                    <i class="bi bi-trash-fill"></i>
                  </a>
                </div>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
      <% } %>
    </div>
  </div>
</div>

<jsp:include page="/admin/admin-footer.jsp" />
