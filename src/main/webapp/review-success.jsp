<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("pageTitle", "Review Submitted — HotServe");
    String ctx = request.getContextPath();
    String error = request.getParameter("error");
    boolean isDuplicate = "duplicate".equals(error);
    boolean isNone = "none".equals(error);
%>
<jsp:include page="header.jsp" />

<div style="min-height:60vh; display:flex; align-items:center; justify-content:center; padding:40px 20px;">
  <div style="text-align:center; max-width:480px;">
    <% if (isNone) { %>
      <div style="font-size:3.5rem; margin-bottom:16px;">🤔</div>
      <h2 style="font-size:1.6rem; font-weight:800; color:var(--color-text); margin-bottom:10px;">No Ratings Selected</h2>
      <p style="color:var(--color-text-muted); font-size:.95rem; line-height:1.7; margin-bottom:28px;">
        It looks like you did not select any star ratings. Go back and tap the stars to rate your dishes!
      </p>
    <% } else if (isDuplicate) { %>
      <div style="font-size:3.5rem; margin-bottom:16px;">😊</div>
      <h2 style="font-size:1.6rem; font-weight:800; color:var(--color-text); margin-bottom:10px;">Already Reviewed!</h2>
      <p style="color:var(--color-text-muted); font-size:.95rem; line-height:1.7; margin-bottom:28px;">
        You have already submitted a review for this item. Each dish can only be reviewed once per order.
      </p>
    <% } else { %>
      <div style="font-size:3.5rem; margin-bottom:16px;">⭐</div>
      <h2 style="font-size:1.6rem; font-weight:800; color:var(--color-text); margin-bottom:10px;">Thank You for Your Review!</h2>
      <p style="color:var(--color-text-muted); font-size:.95rem; line-height:1.7; margin-bottom:28px;">
        Your feedback helps other customers discover great dishes. We really appreciate you taking the time to share your experience!
      </p>
    <% } %>
    <div style="display:flex; gap:12px; justify-content:center; flex-wrap:wrap;">
      <a href="<%= ctx %>/menu" class="btn btn-brand">Browse Menu</a>
      <a href="<%= ctx %>/index.jsp" class="btn btn-outline-brand">Back to Home</a>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
