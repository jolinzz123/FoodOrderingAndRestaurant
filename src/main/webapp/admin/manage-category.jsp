<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.Category, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Manage Categories");
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<jsp:include page="/header.jsp" />

<div class="container-fluid px-0">
  <div class="row g-0">

    <!-- Sidebar -->
    <nav class="col-md-2 admin-sidebar">
      <div class="text-center mb-3 px-3" style="color:#A5D6A7; font-weight:700; font-size:0.8rem; letter-spacing:1px;">ADMIN PANEL</div>
      <a href="<%= ctx %>/admin/dashboard.jsp">&#x1F4CA; Dashboard</a>
      <a href="<%= ctx %>/admin/food">&#x1F37D; Manage Food</a>
      <a href="<%= ctx %>/admin/category" class="active">&#x1F3F7; Categories</a>
      <a href="<%= ctx %>/admin/orders">&#x1F4CB; Orders</a>
      <hr style="border-color:rgba(255,255,255,0.2); margin:12px 20px;">
      <a href="<%= ctx %>/index.jsp">&#x2190; Back to Site</a>
    </nav>

    <!-- Main Content -->
    <main class="col-md-10 p-4">
      <h3 class="mb-4">Manage Categories</h3>

      <div class="row g-4">
        <!-- Add Category Form -->
        <div class="col-md-4">
          <div class="card h-100" style="border:1px solid var(--color-border); border-radius:var(--radius);">
            <div class="card-body p-4">
              <h5 class="mb-3">Add New Category</h5>
              <form method="post" action="<%= ctx %>/admin/category">
                <div class="mb-3">
                  <label class="form-label">Category Name <span class="text-danger">*</span></label>
                  <input type="text" name="name" class="form-control" placeholder="e.g. Drinks, Meals, Desserts" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Add Category</button>
              </form>

              <hr>
              <p class="text-muted" style="font-size:0.85rem;">
                Categories help customers filter the menu. Deleting a category will not delete food items in that category,
                but they will lose their category assignment.
              </p>
            </div>
          </div>
        </div>

        <!-- Categories Table -->
        <div class="col-md-8">
          <h5 class="mb-3">All Categories (<%= categories != null ? categories.size() : 0 %>)</h5>
          <% if (categories == null || categories.isEmpty()) { %>
            <p class="text-muted">No categories yet. Add one to get started.</p>
          <% } else { %>
          <div class="table-responsive">
            <table class="table table-hover table-brand align-middle">
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
                       class="btn btn-sm btn-outline-danger"
                       onclick="return confirm('Delete category \'<%= c.getName() %>\'? Food items in this category will lose their assignment.')">
                      Delete
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

    </main>
  </div>
</div>

<jsp:include page="/footer.jsp" />
