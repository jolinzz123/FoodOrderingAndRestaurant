<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("pageTitle", "Sign Up — FoodOrder");
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
    String username = (String) request.getAttribute("username");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    if (username == null) username = "";
    if (email == null) email = "";
    if (phone == null) phone = "";
%>
<jsp:include page="header.jsp" />

<div class="container">
  <div class="form-card">
    <h3 class="text-center mb-4">Create Your Account</h3>

    <% if (error != null) { %>
      <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <form action="<%= ctx %>/register" method="post" id="registerForm" novalidate>
      <div class="mb-3">
        <label for="username" class="form-label">Username</label>
        <input type="text" class="form-control" id="username" name="username" minlength="3"
               value="<%= username %>" required>
        <div class="invalid-feedback">Username must be at least 3 characters.</div>
      </div>
      <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input type="email" class="form-control" id="email" name="email" value="<%= email %>" required>
        <div class="invalid-feedback">Please enter a valid email address.</div>
      </div>
      <div class="mb-3">
        <label for="phone" class="form-label">Phone Number</label>
        <input type="text" class="form-control" id="phone" name="phone" value="<%= phone %>" placeholder="e.g. 012-3456789" required>
        <div class="invalid-feedback">Please enter a valid phone number.</div>
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <input type="password" class="form-control" id="password" name="password" minlength="6" required>
        <div class="invalid-feedback">Password must be at least 6 characters.</div>
      </div>
      <div class="mb-3">
        <label for="confirmPassword" class="form-label">Confirm Password</label>
        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" minlength="6" required>
        <div class="invalid-feedback">Passwords do not match.</div>
      </div>
      <button type="submit" class="btn btn-brand w-100 mt-2">Sign Up</button>
    </form>
    <p class="text-center mt-3 mb-0">Already have an account? <a href="<%= ctx %>/login.jsp">Log in</a></p>
  </div>
</div>

<jsp:include page="footer.jsp" />
