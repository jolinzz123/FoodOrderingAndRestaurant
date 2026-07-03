<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.Category, java.util.List, com.foodorder.util.WebUtil" %>
<%
    request.setAttribute("pageTitle", "Categories");
    request.setAttribute("activePage", "category");
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String searchQuery = (String) request.getAttribute("searchQuery");
%>
<jsp:include page="/admin/admin-header.jsp" />

<div class="row g-4">
  <!-- Add Category Form -->
  <div class="col-md-4">
    <div class="adm-card h-100">
      <div class="adm-card-title">Add New Category</div>
      <form method="post" action="<%= ctx %>/admin/category">
        <div class="mb-3">
          <label class="form-label">Category Name <span class="text-danger">*</span></label>
          <input type="text" name="name" class="form-control" placeholder="e.g. Drinks, Meals, Desserts" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Add Category</button>
      </form>

      <hr class="my-3">
      <p class="text-muted mb-0" style="font-size:0.83rem;">
        Deleting a category will not delete food items in that category,
        but they will lose their category assignment.
      </p>
    </div>
  </div>

  <!-- Categories Table -->
  <div class="col-md-8">
    <div class="adm-card">
      <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
        <div class="adm-card-title mb-0">All Categories</div>
        <div class="d-flex align-items-center flex-wrap gap-2 adm-list-toolbar-right">
          <form method="get" action="<%= ctx %>/admin/category" class="d-flex flex-grow-1">
            <div class="input-group input-group-sm">
              <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
              <input type="text" name="q" class="form-control" placeholder="Search categories..."
                     value="<%= searchQuery != null ? WebUtil.escapeHtml(searchQuery) : "" %>">
              <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                <a href="<%= ctx %>/admin/category" class="btn btn-outline-secondary" title="Clear search"><i class="bi bi-x-lg"></i></a>
              <% } %>
            </div>
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
            <% for (Category c : categories) { %>
            <tr>
              <td><%= c.getId() %></td>
              <td>
                <span class="badge-category fs-6 px-3 py-2"><%= c.getName() %></span>
              </td>
              <td>
                <a href="<%= ctx %>/admin/category?action=delete&id=<%= c.getId() %>"
                   class="btn btn-sm btn-icon-delete" title="Delete"
                   onclick="return confirm('Delete category \'<%= c.getName() %>\'?')">
                  <i class="bi bi-trash-fill"></i>

                </a>
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
