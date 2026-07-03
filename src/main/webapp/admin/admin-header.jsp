<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String ctx = request.getContextPath();
    Object titleAttr = request.getAttribute("pageTitle");
    String pageTitle = (titleAttr != null) ? titleAttr.toString() : "Admin";
    String activePage = (String) request.getAttribute("activePage");
    if (activePage == null) activePage = "";
    String avatarLetter = (currentUser != null && currentUser.getUsername().length() > 0)
        ? String.valueOf(currentUser.getUsername().charAt(0)).toUpperCase() : "A";
    String username = (currentUser != null) ? currentUser.getUsername() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> — HotServe</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700&family=Inter:wght@400;500;600&family=Nunito:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <link rel="stylesheet" href="<%= ctx %>/css/admin.css">
</head>
<body class="admin-body">

<div class="admin-layout">

  <!-- ===== Sidebar ===== -->
  <nav class="adm-sidebar">
    <div class="adm-brand">
      <span class="brand-icon">🥗</span>
      <span class="brand-name">HotServe</span>
      <button id="sidebarToggle" class="adm-toggle-btn" title="Toggle sidebar">
        <span></span><span></span><span></span>
      </button>
    </div>

    <div class="adm-nav">
      <a href="<%= ctx %>/admin/dashboard.jsp" class="adm-nav-item <%= "dashboard".equals(activePage) ? "active" : "" %>">
        <i class="bi bi-speedometer2"></i>
        <span>Dashboard</span>
      </a>
      <a href="<%= ctx %>/admin/category" class="adm-nav-item <%= "category".equals(activePage) ? "active" : "" %>">
        <i class="bi bi-collection-fill"></i>
        <span>Categories</span>
      </a>
      <a href="<%= ctx %>/admin/food" class="adm-nav-item <%= "food".equals(activePage) ? "active" : "" %>">
        <i class="bi bi-basket-fill"></i>
        <span>Products</span>
      </a>
      <a href="<%= ctx %>/admin/orders" class="adm-nav-item <%= "orders".equals(activePage) ? "active" : "" %>">
        <i class="bi bi-receipt"></i>
        <span>Orders</span>
      </a>
      <a href="<%= ctx %>/admin/users" class="adm-nav-item <%= "users".equals(activePage) ? "active" : "" %>">
        <i class="bi bi-people-fill"></i>
        <span>Users</span>
      </a>
    </div>

    <div class="adm-sidebar-footer">
      <div class="adm-user-info">
        <div class="adm-user-avatar"><%= avatarLetter %></div>
        <div>
          <div class="adm-user-name"><%= username %></div>
          <div class="adm-user-role">Administrator</div>
        </div>
      </div>
      <a href="<%= ctx %>/logout" class="adm-logout-btn" title="Logout">
        <i class="bi bi-box-arrow-right"></i> <span>Logout</span>
      </a>
    </div>
  </nav>

  <!-- ===== Content area ===== -->
  <div class="adm-content">
    <div class="adm-topbar">
      <button id="mobileSidebarToggle" class="adm-mobile-toggle-btn" title="Menu">
        <span></span><span></span><span></span>
      </button>
      <h4 class="adm-page-title"><%= pageTitle %></h4>
    </div>
    <main class="adm-main">
<div class="adm-sidebar-backdrop" id="sidebarBackdrop"></div>
<script>
  document.getElementById('sidebarToggle').addEventListener('click', function() {
    document.querySelector('.admin-layout').classList.toggle('sidebar-collapsed');
    document.querySelector('.admin-layout').classList.toggle('mobile-sidebar-open');
  });
  document.getElementById('mobileSidebarToggle').addEventListener('click', function() {
    document.querySelector('.admin-layout').classList.toggle('mobile-sidebar-open');
  });
  document.getElementById('sidebarBackdrop').addEventListener('click', function() {
    document.querySelector('.admin-layout').classList.remove('mobile-sidebar-open');
  });
</script>
