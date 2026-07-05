<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%
    request.setAttribute("pageTitle", "Oops! — HotServe");
    String ctx = request.getContextPath();
%>
<jsp:include page="header.jsp" />

<div class="container py-5 text-center">
  <h1 style="font-size:4rem; color: var(--color-primary);">🍽️</h1>
  <h2>Something went off the menu.</h2>
  <p class="text-muted">The page you're looking for doesn't exist or an error occurred.</p>
  <a href="<%= ctx %>/index.jsp" class="btn btn-brand mt-3">Back to Home</a>
</div>

<jsp:include page="footer.jsp" />
