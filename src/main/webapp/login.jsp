<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("pageTitle", "Log In — FoodOrder");
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<jsp:include page="header.jsp" />

<div class="container">
  <div class="form-card">
    <h3 class="text-center mb-4">Welcome Back</h3>

    <% if (message != null) { %>
      <div class="alert alert-success"><%= message %></div>
    <% } %>
    <% if (error != null) { %>
      <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <form action="<%= ctx %>/login" method="post" id="loginForm" novalidate>
      <div class="mb-3">
        <label for="username" class="form-label">Username</label>
        <input type="text" class="form-control" id="username" name="username" required>
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <input type="password" class="form-control" id="password" name="password" required>
      </div>
      <button type="submit" class="btn btn-brand w-100 mt-2">Log In</button>
    </form>
    <p class="text-center mt-3 mb-0">New here? <a href="<%= ctx %>/register.jsp">Create an account</a></p>
    <p class="text-center text-muted small mt-2">Admin demo login: <code>admin</code> / <code>admin123</code></p>
  </div>
</div>

<jsp:include page="footer.jsp" />
