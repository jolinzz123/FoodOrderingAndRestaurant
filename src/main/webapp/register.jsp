<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%

    request.setAttribute("pageTitle", "Sign Up — HotServe");
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

<div class="auth-page">
<div class="auth-wrap">

  <div class="panel-form">
    <div class="form-card">
      <h1 class="auth-title">Create Your Account</h1>
      <p class="auth-sub">Join HotServe and start ordering in minutes.</p>

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
           <input type="password" class="form-control" id="password" name="password" minlength="8" required>
        <div class="invalid-feedback">At least 8 characters, with letters and numbers.</div>
       </div>

        <div class="mb-3">
           <label for="confirmPassword" class="form-label">Confirm Password</label>
           <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" minlength="8" required>
        <div class="invalid-feedback">Doesn't match.</div>
       </div>

        <button type="submit" class="btn btn-brand w-100 mt-2">Sign Up</button>
      </form>
      <p class="text-center mt-3 mb-0">Already have an account? <a href="<%= ctx %>/login.jsp">Log in</a></p>
    </div>
  </div>

  <div class="panel-art">
    <div class="deco-icon float-slow" style="top:14%; left:12%; width:34px;">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M7 3v7a2 2 0 0 0 2 2h0a2 2 0 0 0 2-2V3M7 3v18M11 3v7M15 3c-1.5 2-1.5 5 0 7v8"/></svg>
    </div>
    <div class="deco-icon float-slow delay1" style="top:70%; left:10%; width:30px;">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 3"/></svg>
    </div>
    <div class="deco-icon float-slow delay2" style="top:20%; right:10%; width:32px;">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M4 10h16l-1.5 8a2 2 0 0 1-2 1.7H7.5a2 2 0 0 1-2-1.7L4 10Z"/><path d="M9 10V6a3 3 0 0 1 6 0v4"/></svg>
    </div>
    <div class="deco-icon float-slow" style="bottom:24%; right:14%; width:28px;">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M6 3v18M6 3c-1 3 0 5 0 8M18 3v18M18 8c-3 1-3 4 0 5"/></svg>
    </div>

    <svg width="260" height="260" viewBox="0 0 260 260" class="bowl-illustration">
      <g class="steam" opacity=".9">
        <path d="M100 95 C90 80, 100 70, 92 55" stroke="#fff" stroke-width="4" fill="none" stroke-linecap="round"/>
        <path d="M130 95 C120 78, 132 66, 124 48" stroke="#fff" stroke-width="4" fill="none" stroke-linecap="round"/>
        <path d="M160 95 C150 80, 160 70, 152 55" stroke="#fff" stroke-width="4" fill="none" stroke-linecap="round"/>
      </g>
      <path d="M55 130 Q130 190 205 130 L195 150 Q130 200 65 150 Z" fill="#fff"/>
      <ellipse cx="130" cy="130" rx="75" ry="22" fill="#fbeee6"/>
      <ellipse cx="130" cy="127" rx="63" ry="16" fill="#ffb199"/>
      <path d="M95 122c6-6 14 6 20 0s14 6 20 0s14 6 20 0" stroke="#e88a5f" stroke-width="4" fill="none" stroke-linecap="round"/>
      <circle cx="105" cy="118" r="5" fill="#7ec98f"/>
      <circle cx="150" cy="115" r="4" fill="#f4c95d"/>
      <circle cx="130" cy="122" r="4.5" fill="#e8605a"/>
      <rect x="172" y="70" width="6" height="90" rx="3" fill="#fff" transform="rotate(18 175 115)"/>
      <rect x="182" y="66" width="6" height="90" rx="3" fill="#f3f0ff" transform="rotate(18 185 111)"/>
    </svg>

    <div class="auth-caption">
      <h2>Join the table</h2>
      <p>Create an account to save your favorites, track orders, and get member-only deals.</p>
    </div>
  </div>

</div>
</div>

<jsp:include page="footer.jsp" />