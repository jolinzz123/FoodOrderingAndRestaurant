<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodorder.model.CartItem, java.util.Map, java.util.LinkedHashMap, java.math.BigDecimal" %>
<%
    request.setAttribute("pageTitle", "Checkout — HotServe");
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");

    Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
    if (cart == null) cart = new LinkedHashMap<>();
    BigDecimal cartTotal = BigDecimal.ZERO;
    for (CartItem ci : cart.values()) cartTotal = cartTotal.add(ci.getSubtotal());
%>
<jsp:include page="header.jsp" />

<style>
/* ── Checkout page layout ─────────────────────────── */
.co-page { max-width: 1080px; margin: 0 auto; padding: 40px 16px 60px; }
.co-page h2 { font-size: 1.6rem; font-weight: 800; color: var(--color-text); margin-bottom: 32px; }

/* Steps indicator */
.co-steps { display: flex; align-items: center; gap: 0; margin-bottom: 36px; }
.co-step { display: flex; align-items: center; gap: 8px; font-size: .82rem; font-weight: 600; color: #bbb; }
.co-step-num { width: 30px; height: 30px; border-radius: 50%; background: #e8e4f4; color: #bbb; display: flex; align-items: center; justify-content: center; font-size: .78rem; font-weight: 800; flex-shrink: 0; }
.co-step.active .co-step-num { background: #7C6FE8; color: #fff; }
.co-step.active { color: #7C6FE8; }
.co-step.done .co-step-num { background: #7C6FE8; color: #fff; }
.co-step.done { color: #7C6FE8; }
.co-step-line { flex: 1; height: 2px; background: #e8e4f4; margin: 0 10px; min-width: 30px; transition: background .3s; }
.co-step-line.done { background: #7C6FE8; }

/* Cards */
.co-card {
  background: #fff; border: 1px solid var(--color-border);
  border-radius: 18px; padding: 24px 28px; margin-bottom: 20px;
}
.co-card-title {
  font-size: .72rem; font-weight: 800; text-transform: uppercase;
  letter-spacing: .1em; color: var(--color-text-muted); margin-bottom: 18px;
  display: flex; align-items: center; gap: 8px;
}
.co-card-title-icon { font-size: 1rem; }

/* Order items */
.co-item-row {
  display: flex; align-items: center; gap: 14px;
  padding: 12px 0; border-bottom: 1px solid var(--color-border);
}
.co-item-row:last-child { border-bottom: none; padding-bottom: 0; }
.co-item-img { width: 58px; height: 58px; object-fit: cover; border-radius: 10px; flex-shrink: 0; }
.co-item-info { flex: 1; min-width: 0; }
.co-item-name { font-weight: 700; font-size: .9rem; color: var(--color-text); }
.co-item-addons { font-size: .75rem; color: var(--color-text-muted); margin-top: 2px; }
.co-item-qty-badge {
  display: inline-block; font-size: .78rem; color: var(--color-text-muted); margin-top: 2px;
}
.co-item-price { font-weight: 700; color: var(--color-primary); white-space: nowrap; font-size: .92rem; }
.co-remove-btn {
  background: none; border: 1px solid #f0b0b0; border-radius: 8px;
  color: #d9534f; font-size: 1rem; width: 32px; height: 32px;
  display: flex; align-items: center; justify-content: center; cursor: pointer;
  transition: background .15s; flex-shrink: 0;
}
.co-remove-btn:hover { background: #fff0f0; }

/* Address input */
.co-address-input {
  width: 100%; border: 2px solid var(--color-border); border-radius: 12px;
  padding: 13px 16px; font-size: .9rem; color: var(--color-text);
  transition: border-color .2s; outline: none; background: var(--color-bg);
}
.co-address-input:focus { border-color: var(--color-accent); }

/* Payment method cards */
.co-pay-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
.co-pay-card {
  border: 2px solid var(--color-border); border-radius: 14px; padding: 14px 10px;
  text-align: center; cursor: pointer; transition: border-color .2s, background .2s;
  user-select: none;
}
.co-pay-card:hover { border-color: #b8aff0; background: #f7f5ff; }
.co-pay-card.selected { border-color: var(--color-accent); background: #f0ecff; }
.co-pay-card-icon { font-size: 1.6rem; display: block; margin-bottom: 6px; }
.co-pay-card-label { font-size: .78rem; font-weight: 700; color: var(--color-text); }
.co-pay-card.selected .co-pay-card-label { color: var(--color-accent); }

/* Summary panel */
.co-summary { background: #fff; border: 1px solid var(--color-border); border-radius: 18px; padding: 24px 28px; position: sticky; top: 20px; }
.co-summary-title { font-size: .72rem; font-weight: 800; text-transform: uppercase; letter-spacing: .1em; color: var(--color-text-muted); margin-bottom: 18px; }
.co-sum-row { display: flex; justify-content: space-between; font-size: .88rem; color: var(--color-text-muted); margin-bottom: 10px; }
.co-sum-row span:last-child { font-weight: 600; color: var(--color-text); }
.co-sum-divider { border: none; border-top: 1px solid var(--color-border); margin: 14px 0; }
.co-sum-total { display: flex; justify-content: space-between; font-size: 1.05rem; font-weight: 800; color: var(--color-text); margin-bottom: 20px; }
.btn-place-order {
  display: block; width: 100%; padding: 14px;
  background: var(--color-accent); color: #fff;
  border: none; border-radius: 14px; font-size: .95rem; font-weight: 700;
  cursor: pointer; transition: opacity .2s; text-align: center;
}
.btn-place-order:hover { opacity: .9; }
.co-secure-note { text-align: center; font-size: .72rem; color: var(--color-text-muted); margin-top: 10px; }
</style>

<div class="co-page">
  <h2>Checkout</h2>

  <!-- Steps -->
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
    <div class="co-step-line"></div>
    <div class="co-step">
      <div class="co-step-num">3</div>
      <span>Confirmation</span>
    </div>
  </div>

  <% if (error != null) { %>
    <div class="alert alert-danger mb-4"><%= error %></div>
  <% } %>

  <% if (cart.isEmpty()) { %>
    <div class="co-card text-center py-5">
      <p style="font-size:2.5rem;">🛒</p>
      <p class="text-muted mb-3">Your cart is empty — add some items before checking out.</p>
      <a href="<%= ctx %>/menu" class="btn btn-brand">Browse Menu</a>
    </div>
  <% } else { %>

  <div class="row g-4">
    <!-- LEFT column -->
    <div class="col-lg-7">

      <!-- Order items -->
      <div class="co-card">
        <div class="co-card-title">
          <span class="co-card-title-icon">🧾</span> Your Order
        </div>
        <% for (CartItem item : cart.values()) {
             String thumb = item.getImageUrl();
             if (thumb == null || thumb.isEmpty()) thumb = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=80&q=70";
             else if (!thumb.startsWith("http")) thumb = ctx + "/" + thumb;
        %>
        <div class="co-item-row">
          <img src="<%= thumb %>" alt="<%= item.getFoodName() %>" class="co-item-img"
               onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=80&q=70'">
          <div class="co-item-info">
            <div class="co-item-name"><%= item.getFoodName() %></div>
            <% if (item.getAddons() != null && !item.getAddons().isEmpty()) { %>
              <div class="co-item-addons">+ <%= item.getAddons() %></div>
            <% } %>
            <span class="co-item-qty-badge">Qty: <%= item.getQuantity() %></span>
          </div>
          <div class="co-item-price">RM <%= String.format("%,.2f", item.getSubtotal()) %></div>
          <form action="<%= ctx %>/cart" method="post" style="margin:0;">
            <input type="hidden" name="action" value="remove">
            <input type="hidden" name="cartKey" value="<%= item.getCartKey() %>">
            <input type="hidden" name="returnTo" value="/checkout">
            <button type="submit" class="co-remove-btn" title="Remove">🗑</button>
          </form>
        </div>
        <% } %>
      </div>

      <!-- Delivery address -->
      <div class="co-card">
        <div class="co-card-title">
          <span class="co-card-title-icon">📍</span> Delivery Address
        </div>
        <input type="text" id="coAddress" class="co-address-input"
               placeholder="Enter your full delivery address…" autocomplete="street-address">
        <div id="coAddressErr" style="color:#d9534f;font-size:.8rem;margin-top:6px;display:none;">
          Please enter your delivery address.
        </div>
      </div>

      <!-- Payment method -->
      <div class="co-card">
        <div class="co-card-title">
          <span class="co-card-title-icon">💳</span> Payment Method
        </div>
        <div class="co-pay-grid">
          <div class="co-pay-card" data-pay="cod" onclick="selectPay(this)">
            <span class="co-pay-card-icon">💵</span>
            <div class="co-pay-card-label">Cash on Delivery</div>
          </div>
          <div class="co-pay-card" data-pay="card" onclick="selectPay(this)">
            <span class="co-pay-card-icon">💳</span>
            <div class="co-pay-card-label">Credit / Debit Card</div>
          </div>
          <div class="co-pay-card" data-pay="ewallet" onclick="selectPay(this)">
            <span class="co-pay-card-icon">📱</span>
            <div class="co-pay-card-label">E-Wallet / QR</div>
          </div>
        </div>
        <div id="coPayErr" style="color:#d9534f;font-size:.8rem;margin-top:10px;display:none;">
          Please select a payment method.
        </div>
      </div>

    </div><!-- end left col -->

    <!-- RIGHT: summary -->
    <div class="col-lg-5">
      <div class="co-summary">
        <div class="co-summary-title">Payment Summary</div>

        <% for (CartItem item : cart.values()) { %>
        <div class="co-sum-row">
          <span><%= item.getFoodName() %><% if (item.getQuantity() > 1) { %> ×<%= item.getQuantity() %><% } %></span>
          <span>RM <%= String.format("%,.2f", item.getSubtotal()) %></span>
        </div>
        <% } %>

        <hr class="co-sum-divider">
        <%
          java.math.BigDecimal FREE_THRESHOLD = new java.math.BigDecimal("30.00");
          java.math.BigDecimal DELIVERY_FEE   = new java.math.BigDecimal("3.00");
          java.math.BigDecimal deliveryFee    = cartTotal.compareTo(FREE_THRESHOLD) >= 0 ? java.math.BigDecimal.ZERO : DELIVERY_FEE;
          java.math.BigDecimal grandTotal     = cartTotal.add(deliveryFee);
        %>
        <div class="co-sum-row"><span>Subtotal</span><span>RM <%= String.format("%,.2f", cartTotal) %></span></div>
        <div class="co-sum-row">
          <span>Delivery Fee
            <% if (deliveryFee.compareTo(java.math.BigDecimal.ZERO) == 0) { %>
              <span style="font-size:.72rem;color:#22C55E;font-weight:700;margin-left:4px;">FREE</span>
            <% } else { %>
              <span style="font-size:.72rem;color:var(--color-text-muted);margin-left:4px;">(Free above RM30)</span>
            <% } %>
          </span>
          <span><%= deliveryFee.compareTo(java.math.BigDecimal.ZERO) == 0 ? "FREE" : "RM " + String.format("%,.2f", deliveryFee) %></span>
        </div>
        <hr class="co-sum-divider">
        <div class="co-sum-total"><span>Total</span><span>RM <%= String.format("%,.2f", grandTotal) %></span></div>

        <!-- Hidden real form -->
        <form action="<%= ctx %>/checkout" method="post" id="checkoutForm">
          <input type="hidden" name="address" id="hiddenAddress">
          <input type="hidden" name="paymentMethod" id="hiddenPayment">
          <button type="submit" class="btn-place-order"
            style="display:block;width:100%;padding:14px;background:#7C6FE8;color:#fff;border:none;border-radius:14px;font-size:.95rem;font-weight:700;cursor:pointer;">
            Place Order →
          </button>
        </form>
        <div class="co-secure-note">🔒 Secure checkout · No hidden charges</div>
      </div>
    </div>
  </div>

  <% } %>
</div>

<script>
var selectedPay = localStorage.getItem('selectedPayment') || 'cod';

function selectPay(el) {
  document.querySelectorAll('.co-pay-card').forEach(function(c) { c.classList.remove('selected'); });
  el.classList.add('selected');
  selectedPay = el.dataset.pay;
  localStorage.setItem('selectedPayment', selectedPay);
  document.getElementById('coPayErr').style.display = 'none';
}

// Restore payment method from sidebar choice
(function() {
  var card = document.querySelector('.co-pay-card[data-pay="' + selectedPay + '"]');
  if (card) card.classList.add('selected');
  else {
    var first = document.querySelector('.co-pay-card');
    if (first) { first.classList.add('selected'); selectedPay = first.dataset.pay; }
  }
})();

document.getElementById('checkoutForm').addEventListener('submit', function(e) {
  var addr = document.getElementById('coAddress').value.trim();
  var addrErr = document.getElementById('coAddressErr');
  var payErr = document.getElementById('coPayErr');
  var valid = true;

  if (!addr) {
    addrErr.style.display = 'block';
    document.getElementById('coAddress').focus();
    valid = false;
  } else {
    addrErr.style.display = 'none';
  }

  if (!selectedPay) {
    payErr.style.display = 'block';
    valid = false;
  } else {
    payErr.style.display = 'none';
  }

  if (!valid) { e.preventDefault(); return; }

  document.getElementById('hiddenAddress').value = addr;
  document.getElementById('hiddenPayment').value = selectedPay;
});

document.getElementById('coAddress').addEventListener('input', function() {
  if (this.value.trim()) document.getElementById('coAddressErr').style.display = 'none';
});
</script>

<jsp:include page="footer.jsp" />
