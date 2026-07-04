<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("pageTitle", "Message Sent — HotServe");
    String ctx = request.getContextPath();
%>
<jsp:include page="header.jsp" />

<style>
.ct-card { background:#fff; border:1px solid var(--color-border); border-radius:16px; padding:48px 32px; max-width:560px; margin:60px auto; text-align:center; }
.ct-check { font-size:3.5rem; }
.ct-title { font-size:1.6rem; font-weight:800; color:var(--color-text); margin:8px 0 4px; }
.ct-sub { color:var(--color-text-muted); font-size:.95rem; margin-bottom:24px; }
</style>

<div class="container py-5">
  <div class="ct-card">
    <div class="ct-check">✅</div>
    <div class="ct-title">Thanks for reaching out!</div>
    <div class="ct-sub">We'll reply within 1–2 business days.</div>
    <a href="<%= ctx %>/contact.jsp" class="btn btn-outline-brand">Back to Contact</a>
  </div>
</div>

<jsp:include page="footer.jsp" />
