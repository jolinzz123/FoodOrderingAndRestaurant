<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.foodorder.model.OrderItem, com.foodorder.model.User, com.foodorder.dao.ReviewDAO, java.math.BigDecimal" %>
<%
    request.setAttribute("pageTitle", "Order Confirmed — HotServe");
    String ctx = request.getContextPath();
    Object orderIdObj   = request.getAttribute("orderId");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
    BigDecimal orderTotal      = (BigDecimal) request.getAttribute("orderTotal");
    String deliveryAddress     = (String) request.getAttribute("deliveryAddress");
    String paymentMethod       = (String) request.getAttribute("paymentMethod");
    if (orderItems == null) orderItems = java.util.Collections.emptyList();
    if (orderTotal == null) orderTotal = BigDecimal.ZERO;

    String payLabel = "Cash on Delivery";
    if ("card".equals(paymentMethod))    payLabel = "Credit / Debit Card";
    else if ("ewallet".equals(paymentMethod)) payLabel = "E-Wallet";

    // Check which items have already been reviewed (for returning via ?orderId=X)
    User currentUser = (User) session.getAttribute("user");
    int orderId = orderIdObj != null ? (int) orderIdObj : 0;
    ReviewDAO reviewDAO = new ReviewDAO();

    String reviewSuccess = request.getParameter("reviewSuccess");
    String reviewError   = request.getParameter("reviewError");

    // If page loaded via redirect with orderId param but no attributes, try to get orderId from param
    if (orderId == 0) {
        try { orderId = Integer.parseInt(request.getParameter("orderId")); } catch (Exception e) {}
    }
%>
<jsp:include page="header.jsp" />

<style>
.co-steps { display: flex; align-items: center; gap: 0; margin-bottom: 36px; max-width: 640px; margin-left: auto; margin-right: auto; }
.co-step { display: flex; align-items: center; gap: 8px; font-size: .82rem; font-weight: 600; color: #bbb; }
.co-step-num { width: 30px; height: 30px; border-radius: 50%; background: #e8e4f4; color: #bbb; display: flex; align-items: center; justify-content: center; font-size: .78rem; font-weight: 800; flex-shrink: 0; }
.co-step.done .co-step-num { background: #7C6FE8; color: #fff; }
.co-step.done { color: #7C6FE8; }
.co-step-line { flex: 1; height: 2px; background: #e8e4f4; margin: 0 10px; min-width: 30px; }
.co-step-line.done { background: #7C6FE8; }

.oc-card { background:#fff; border:1px solid var(--color-border); border-radius:16px; padding:32px; max-width:640px; margin:0 auto 24px; }
.oc-header { text-align:center; margin-bottom:28px; }
.oc-check { font-size:3.5rem; }
.oc-title { font-size:1.6rem; font-weight:800; color:var(--color-text); margin:8px 0 4px; }
.oc-sub { color:var(--color-text-muted); font-size:.9rem; }
.oc-section { margin-bottom:20px; }
.oc-section-label { font-size:.72rem; font-weight:700; text-transform:uppercase; letter-spacing:.08em; color:var(--color-text-muted); margin-bottom:10px; }
.oc-info-row { display:flex; justify-content:space-between; font-size:.88rem; padding:6px 0; border-bottom:1px solid var(--color-border); }
.oc-info-row:last-child { border-bottom:none; }
.oc-info-val { font-weight:600; color:var(--color-text); }
.oc-total { display:flex; justify-content:space-between; font-size:1rem; font-weight:800; color:var(--color-primary); padding-top:14px; margin-top:8px; border-top:2px solid var(--color-border); }
.oc-actions { display:flex; gap:12px; justify-content:center; margin-top:28px; }

/* Rating section */
.oc-rate-card { background:#fff; border:1px solid var(--color-border); border-radius:16px; padding:28px 32px; max-width:640px; margin:0 auto 24px; }
.oc-rate-title { font-size:1rem; font-weight:800; color:var(--color-text); margin-bottom:6px; }
.oc-rate-sub { font-size:.83rem; color:var(--color-text-muted); margin-bottom:20px; }
.oc-rate-item { border:1px solid var(--color-border); border-radius:12px; padding:16px 18px; margin-bottom:14px; }
.oc-rate-item:last-child { margin-bottom:0; }
.oc-rate-food { font-size:.9rem; font-weight:700; color:var(--color-text); margin-bottom:10px; }
.oc-star-row { display:flex; gap:6px; margin-bottom:10px; }
.oc-star-btn {
  background: none; border: none; font-size: 1.6rem; color: #D8D0C8; cursor: pointer;
  padding: 0; line-height: 1; transition: color .1s, transform .1s;
}
.oc-star-btn:hover, .oc-star-btn.selected { color: #E8A020; }
.oc-star-btn:hover { transform: scale(1.2); }
.oc-rate-comment {
  width: 100%; border: 1.5px solid var(--color-border); border-radius: 8px;
  padding: 8px 12px; font-size: .83rem; color: var(--color-text);
  resize: vertical; min-height: 60px; font-family: inherit;
  transition: border-color .15s;
}
.oc-rate-comment:focus { outline: none; border-color: var(--color-primary); }
.oc-rate-submit {
  margin-top: 10px;
  background: var(--color-primary); color: #fff; border: none;
  border-radius: var(--radius-pill); padding: 9px 22px;
  font-size: .85rem; font-weight: 700; cursor: pointer;
  transition: background .2s;
}
.oc-rate-submit:hover { background: var(--color-primary-dark); }
.oc-rate-done {
  display: flex; align-items: center; gap: 8px;
  color: #22b455; font-size: .88rem; font-weight: 600;
}
.oc-alert { max-width:640px; margin:0 auto 16px; border-radius:10px; padding:12px 18px; font-size:.85rem; font-weight:600; }
.oc-alert-success { background:#e8f8ee; color:#22622a; border:1px solid #b2e0c0; }
.oc-alert-error   { background:#fdecea; color:#932020; border:1px solid #f5c0be; }
</style>

<div class="container py-5">

  <!-- Steps — all completed -->
  <div class="co-steps">
    <div class="co-step done">
      <div class="co-step-num">✓</div>
      <span>Review Order</span>
    </div>
    <div class="co-step-line done"></div>
    <div class="co-step done">
      <div class="co-step-num">✓</div>
      <span>Delivery &amp; Payment</span>
    </div>
    <div class="co-step-line done"></div>
    <div class="co-step done">
      <div class="co-step-num">✓</div>
      <span>Confirmation</span>
    </div>
  </div>

  <!-- Review feedback alerts -->
  <% if ("1".equals(reviewSuccess)) { %>
  <div class="oc-alert oc-alert-success">✓ Your review has been submitted. Thank you!</div>
  <% } else if ("duplicate".equals(reviewError)) { %>
  <div class="oc-alert oc-alert-error">You have already reviewed this item for this order.</div>
  <% } else if ("invalid".equals(reviewError)) { %>
  <div class="oc-alert oc-alert-error">Invalid rating. Please select 1–5 stars.</div>
  <% } %>

  <div class="oc-card">
    <div class="oc-header">
      <div class="oc-check">✅</div>
      <div class="oc-title">Order Confirmed!</div>
      <div class="oc-sub">Thank you! Your order <strong>#<%= orderId > 0 ? orderId : orderIdObj %></strong> has been placed successfully.</div>
    </div>

    <!-- Delivery info -->
    <div class="oc-section">
      <div class="oc-section-label">Delivery Details</div>
      <div class="oc-info-row">
        <span>Address</span>
        <span class="oc-info-val"><%= deliveryAddress != null ? deliveryAddress : "—" %></span>
      </div>
      <div class="oc-info-row">
        <span>Payment</span>
        <span class="oc-info-val"><%= payLabel %></span>
      </div>
    </div>

    <!-- Order items -->
    <div class="oc-section">
      <div class="oc-section-label">Order Summary</div>
      <% for (OrderItem oi : orderItems) { %>
      <div class="oc-info-row">
        <span><%= oi.getFoodName() %> × <%= oi.getQuantity() %>
          <% if (oi.getAddons() != null && !oi.getAddons().isEmpty()) { %>
            <br><small style="color:var(--color-text-muted)"><%= oi.getAddons() %></small>
          <% } %>
        </span>
        <span class="oc-info-val">RM <%= String.format("%,.2f", oi.getSubtotal()) %></span>
      </div>
      <% } %>
      <div class="oc-total">
        <span>Total Paid</span>
        <span>RM <%= String.format("%,.2f", orderTotal) %></span>
      </div>
    </div>

    <div class="oc-actions">
      <a href="<%= ctx %>/menu" class="btn btn-brand">Order More</a>
      <a href="<%= ctx %>/index.jsp" class="btn btn-outline-brand">Back to Home</a>
    </div>
  </div>

  <!-- Rate your food — single form for all items -->
  <%
    boolean anyUnreviewed = false;
    if (currentUser != null && !orderItems.isEmpty()) {
        for (OrderItem oi : orderItems) {
            if (orderId > 0 && !reviewDAO.hasReviewed(currentUser.getId(), oi.getFoodId(), orderId)) {
                anyUnreviewed = true; break;
            }
        }
    }
  %>
  <% if (currentUser != null && !orderItems.isEmpty()) { %>
  <div class="oc-rate-card">
    <div class="oc-rate-title">⭐ Rate Your Food</div>
    <div class="oc-rate-sub">
      <% if (anyUnreviewed) { %>
        Rate the dishes you enjoyed — skip any you'd rather not review. Stars are optional per item.
      <% } else { %>
        You have reviewed all items in this order. Thank you for your feedback!
      <% } %>
    </div>

    <% if (anyUnreviewed) { %>
    <form action="<%= ctx %>/review" method="post" onsubmit="return validateAnyRating()">
      <input type="hidden" name="orderId" value="<%= orderId > 0 ? orderId : orderIdObj %>">

      <% for (OrderItem oi : orderItems) {
           boolean alreadyReviewed = orderId > 0 && reviewDAO.hasReviewed(currentUser.getId(), oi.getFoodId(), orderId);
      %>
      <div class="oc-rate-item">
        <div class="oc-rate-food"><%= oi.getFoodName() %></div>
        <% if (alreadyReviewed) { %>
          <div class="oc-rate-done">✓ Already reviewed</div>
        <% } else { %>
          <input type="hidden" name="foodIds" value="<%= oi.getFoodId() %>">
          <input type="hidden" name="rating_<%= oi.getFoodId() %>" id="ratingInput_<%= oi.getFoodId() %>" value="0">
          <div class="oc-star-row" id="stars_<%= oi.getFoodId() %>">
            <% for (int s = 1; s <= 5; s++) { %>
            <button type="button" class="oc-star-btn"
                    onclick="setRating(<%= oi.getFoodId() %>, <%= s %>)"
                    onmouseover="hoverRating(<%= oi.getFoodId() %>, <%= s %>)"
                    onmouseout="resetHover(<%= oi.getFoodId() %>)">★</button>
            <% } %>
          </div>
          <textarea name="comment_<%= oi.getFoodId() %>" class="oc-rate-comment"
                    placeholder="Optional: leave a comment..."></textarea>
        <% } %>
      </div>
      <% } %>

      <div style="margin-top:18px;">
        <button type="submit" class="oc-rate-submit" style="padding:11px 32px; font-size:.95rem;">
          Submit Reviews
        </button>
        <span style="font-size:.8rem; color:var(--color-text-muted); margin-left:12px;">
          Items without a star rating will be skipped.
        </span>
      </div>
    </form>
    <% } %>
  </div>
  <% } %>

</div>

<script>
var selectedRatings = {};

function setRating(foodId, star) {
  selectedRatings[foodId] = star;
  document.getElementById('ratingInput_' + foodId).value = star;
  renderStars(foodId, star);
}

function hoverRating(foodId, star) {
  renderStars(foodId, star);
}

function resetHover(foodId) {
  renderStars(foodId, selectedRatings[foodId] || 0);
}

function renderStars(foodId, upTo) {
  var container = document.getElementById('stars_' + foodId);
  if (!container) return;
  container.querySelectorAll('.oc-star-btn').forEach(function(btn, idx) {
    btn.classList.toggle('selected', idx < upTo);
  });
}

// At least one item must have a star selected before submitting
function validateAnyRating() {
  var hasAny = Object.values(selectedRatings).some(function(v) { return v > 0; });
  if (!hasAny) {
    alert('Please select at least one star rating before submitting.');
    return false;
  }
  return true;
}
</script>

<jsp:include page="footer.jsp" />
