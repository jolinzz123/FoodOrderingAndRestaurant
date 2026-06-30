<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String ctx = request.getContextPath();
    Object titleAttr = request.getAttribute("pageTitle");
    String pageTitle = (titleAttr != null) ? titleAttr.toString() : "FoodOrder";
    String uri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-foodorder fixed-top">
  <div class="container">
    <a class="navbar-brand" href="<%= ctx %>/index.jsp">🥗 FoodOrder</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMain">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMain">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link <%= uri.endsWith("index.jsp") || uri.endsWith("/FoodOrderingAndRestaurant/") ? "active" : "" %>" href="<%= ctx %>/index.jsp">Home</a></li>
        <li class="nav-item"><a class="nav-link <%= uri.contains("/menu") ? "active" : "" %>" href="<%= ctx %>/menu">Menu</a></li>
        <li class="nav-item"><a class="nav-link <%= uri.endsWith("about.jsp") ? "active" : "" %>" href="<%= ctx %>/about.jsp">About Us</a></li>
        <li class="nav-item"><a class="nav-link <%= uri.endsWith("contact.jsp") ? "active" : "" %>" href="<%= ctx %>/contact.jsp">Contact</a></li>
        <li class="nav-item"><a class="nav-link <%= uri.endsWith("faq.jsp") ? "active" : "" %>" href="<%= ctx %>/faq.jsp">FAQ</a></li>
        <% if (currentUser != null && currentUser.isAdmin()) { %>
          <li class="nav-item"><a class="nav-link <%= uri.contains("/admin/") ? "active" : "" %>" href="<%= ctx %>/admin/dashboard.jsp">Admin</a></li>
        <% } %>
      </ul>
      <ul class="navbar-nav align-items-lg-center">
        <% if (currentUser != null) { %>
            <li class="nav-item me-2"><span class="nav-link">Hi, <%= currentUser.getUsername() %></span></li>
            <li class="nav-item me-2"><a class="nav-link btn-cart" href="<%= ctx %>/cart">🛒 Cart</a></li>
            <li class="nav-item"><a class="nav-link" href="<%= ctx %>/logout">Logout</a></li>
        <% } else { %>
            <li class="nav-item"><a class="nav-link" href="<%= ctx %>/login.jsp">Login</a></li>
            <li class="nav-item"><a class="nav-link btn-cart" href="<%= ctx %>/register.jsp">Sign Up</a></li>
        <% } %>
      </ul>
    </div>
  </div>
</nav>
