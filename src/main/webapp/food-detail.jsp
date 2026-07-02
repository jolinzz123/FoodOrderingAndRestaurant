<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foodorder.model.FoodItem, com.foodorder.model.User, com.foodorder.model.Addon, java.util.List" %>
<%
    FoodItem item = (FoodItem) request.getAttribute("item");
    request.setAttribute("pageTitle", item.getName() + " — HotServe");
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
    User currentUser = (User) session.getAttribute("user");
    @SuppressWarnings("unchecked")
    List<Addon> addons = (List<Addon>) request.getAttribute("addons");

    // Star rendering helper
    double rating = item.getRating();
    int fullStars = (int) rating;
    boolean halfStar = (rating - fullStars) >= 0.5;
%>
<jsp:include page="header.jsp" />

<div class="fd-page">
  <div class="fd-back">
    <a href="<%= ctx %>/menu">← Back to Menu</a>
  </div>

  <!-- Main compact card -->
  <div class="fd-card">

    <!-- LEFT: image -->
    <div class="fd-img-col">
      <img src="<%= ctx %>/<%= item.getImageUrl() %>"
           alt="<%= item.getName() %>"
           class="fd-img"
           onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80'">
      <!-- Nutrition strip inside image col -->
      <div class="fd-nutr">
        <% if (item.getNutritionalInfo() != null && !item.getNutritionalInfo().isEmpty()) { %>
        <div class="fd-nutr-title">Nutritional Info</div>
        <div class="fd-nutr-row"><%= item.getNutritionalInfo() %></div>
        <% } %>
        <% if (item.getIngredients() != null && !item.getIngredients().isEmpty()) { %>
        <div class="fd-nutr-title" style="margin-top:10px;">Ingredients</div>
        <div class="fd-nutr-row"><%= item.getIngredients() %></div>
        <% } %>
      </div>
    </div>

    <!-- RIGHT: info + order -->
    <div class="fd-info-col">

      <!-- Header -->
      <div class="fd-header">
        <span class="fd-cat-badge"><%= item.getCategoryName() %></span>
        <h2 class="fd-title"><%= item.getName() %></h2>
        <p class="fd-desc"><%= item.getDescription() %></p>

        <!-- Rating row -->
        <div class="fd-rating-row">
          <span class="fd-stars">
            <% for (int s = 1; s <= 5; s++) {
                if (s <= fullStars) { %><span class="fd-star filled">★</span><%
                } else if (s == fullStars + 1 && halfStar) { %><span class="fd-star half">★</span><%
                } else { %><span class="fd-star empty">★</span><% }
            } %>
          </span>
          <span class="fd-rating-num"><%= String.format("%.1f", rating) %></span>
          <span class="fd-rating-lbl">out of 5</span>
        </div>
      </div>

      <div class="fd-divider"></div>

      <!-- Order form -->
      <% if (error != null) { %>
        <div class="alert alert-danger py-2 mb-2" style="font-size:.85rem;"><%= error %></div>
      <% } %>

      <form action="<%= ctx %>/cart" method="post" class="fd-form">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="foodId" value="<%= item.getId() %>">
        <input type="hidden" name="returnTo" value="/menu">

        <!-- Qty + price row -->
        <div class="fd-order-top">
          <div>
            <div class="fd-label">Quantity</div>
            <div class="fd-qty-ctrl">
              <button type="button" class="fd-qty-btn" onclick="changeQty(-1)">−</button>
              <input type="number" id="qtyInput" name="quantity" value="1" min="1" max="20"
                     class="fd-qty-num" readonly>
              <button type="button" class="fd-qty-btn" onclick="changeQty(1)">+</button>
            </div>
          </div>
          <div class="fd-price-block">
            <div class="fd-price-label">Price</div>
            <div class="fd-price">RM <%= String.format("%,.2f", item.getPrice()) %></div>
          </div>
        </div>

        <!-- Add-ons -->
        <% if (addons != null && !addons.isEmpty()) { %>
        <div class="fd-addons">
          <div class="fd-label">Add-ons</div>
          <div class="fd-addon-grid">
            <% for (Addon a : addons) { %>
            <label class="fd-addon-chip">
              <input type="checkbox" name="addons" value="<%= a.getId() %>">
              <span class="fd-addon-inner">
                <span class="fd-addon-name"><%= a.getName() %></span>
                <span class="fd-addon-price">
                  <% if (a.getExtraPrice() != null && a.getExtraPrice().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                    +RM <%= String.format("%.2f", a.getExtraPrice()) %>
                  <% } else { %>Free<% } %>
                </span>
              </span>
            </label>
            <% } %>
          </div>
        </div>
        <% } %>

        <!-- CTA -->
        <% if (currentUser != null) { %>
          <button type="submit" class="fd-btn-add">Add to Cart</button>
        <% } else { %>
          <a href="<%= ctx %>/login.jsp" class="fd-btn-add">Log in to Order</a>
        <% } %>
      </form>

    </div><!-- end info col -->
  </div><!-- end fd-card -->

  <!-- Ratings & Reviews card -->
  <div class="fd-reviews-card">
    <h5 class="fd-reviews-title">Ratings &amp; Reviews</h5>
    <div class="fd-reviews-body">
      <!-- Big score -->
      <div class="fd-score-block">
        <div class="fd-score-num"><%= String.format("%.1f", rating) %></div>
        <div class="fd-score-stars">
          <% for (int s = 1; s <= 5; s++) {
              if (s <= fullStars) { %><span class="fd-star filled">★</span><%
              } else if (s == fullStars + 1 && halfStar) { %><span class="fd-star half">★</span><%
              } else { %><span class="fd-star empty">★</span><% }
          } %>
        </div>
        <div class="fd-score-lbl">Customer Rating</div>
      </div>
      <!-- Bar chart (visual only, proportional to rating) -->
      <div class="fd-bar-block">
        <% int[] bars = {0, 0, 0, 0, 0};
           int rInt = (int) Math.round(rating);
           bars[rInt - 1] = 70;
           if (rInt > 1) bars[rInt - 2] = 20;
           if (rInt < 5) bars[rInt] = 8;
           if (rInt > 2) bars[rInt - 3] = 2;
           for (int b = 5; b >= 1; b--) { %>
        <div class="fd-bar-row">
          <span class="fd-bar-lbl"><%= b %>★</span>
          <div class="fd-bar-track">
            <div class="fd-bar-fill" style="width:<%= bars[b-1] %>%"></div>
          </div>
          <span class="fd-bar-pct"><%= bars[b-1] %>%</span>
        </div>
        <% } %>
      </div>
    </div>
    <p class="fd-reviews-note">Reviews are collected from verified orders. Log in and place an order to share your feedback.</p>
  </div>

</div><!-- end fd-page -->

<style>
.fd-page {
  max-width: 980px;
  margin: 0 auto;
  padding: 28px 20px 60px;
}
.fd-back a {
  font-size: .85rem;
  color: var(--color-text-muted);
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  margin-bottom: 18px;
}
.fd-back a:hover { color: var(--color-primary); }

/* Main card */
.fd-card {
  display: flex;
  gap: 0;
  background: #fff;
  border-radius: 24px;
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-soft);
  overflow: hidden;
  margin-bottom: 24px;
}
.fd-img-col {
  width: 340px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
}
.fd-img {
  width: 100%;
  height: 240px;
  object-fit: cover;
  display: block;
}
.fd-nutr {
  flex: 1;
  background: var(--color-bg-soft);
  padding: 14px 16px;
  border-top: 1px solid var(--color-border);
}
.fd-nutr-title {
  font-size: .68rem;
  font-weight: 800;
  letter-spacing: .08em;
  text-transform: uppercase;
  color: var(--color-primary);
  margin-bottom: 5px;
}
.fd-nutr-row {
  font-size: .78rem;
  color: var(--color-text-muted);
  line-height: 1.6;
}
.fd-info-col {
  flex: 1;
  padding: 24px 28px;
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.fd-header { margin-bottom: 0; }
.fd-cat-badge {
  display: inline-block;
  background: var(--color-accent);
  color: var(--color-primary-dark);
  border-radius: 50px;
  padding: 3px 12px;
  font-size: .72rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: .05em;
  margin-bottom: 8px;
}
.fd-title {
  font-size: 1.6rem;
  font-weight: 800;
  color: var(--color-text);
  margin-bottom: 6px;
  line-height: 1.2;
}
.fd-desc {
  font-size: .88rem;
  color: var(--color-text-muted);
  line-height: 1.6;
  margin-bottom: 10px;
}
.fd-rating-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}
.fd-stars { display: flex; gap: 1px; }
.fd-star { font-size: 1rem; }
.fd-star.filled { color: #E8A020; }
.fd-star.half { color: #E8A020; opacity: .6; }
.fd-star.empty { color: #D8D0C8; }
.fd-rating-num { font-size: 1rem; font-weight: 800; color: var(--color-text); }
.fd-rating-lbl { font-size: .78rem; color: var(--color-text-muted); }

.fd-divider { height: 1px; background: var(--color-border); margin: 14px 0; }

/* Order form */
.fd-form { display: flex; flex-direction: column; flex: 1; }
.fd-label {
  font-size: .72rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: .07em;
  color: var(--color-text-muted);
  margin-bottom: 6px;
}
.fd-order-top {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 14px;
}
.fd-qty-ctrl {
  display: flex;
  align-items: center;
  border: 1.5px solid var(--color-border);
  border-radius: var(--radius-sm);
  overflow: hidden;
  width: fit-content;
}
.fd-qty-btn {
  width: 32px; height: 32px;
  background: var(--color-bg-soft);
  border: none;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  color: var(--color-primary);
  transition: background .15s;
}
.fd-qty-btn:hover { background: var(--color-primary); color: #fff; }
.fd-qty-num {
  width: 40px;
  text-align: center;
  font-size: .9rem;
  font-weight: 700;
  border: none;
  outline: none;
  background: #fff;
  color: var(--color-text);
  -moz-appearance: textfield;
}
.fd-qty-num::-webkit-outer-spin-button,
.fd-qty-num::-webkit-inner-spin-button { -webkit-appearance: none; }
.fd-price-block { text-align: right; }
.fd-price-label { font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .07em; color: var(--color-text-muted); margin-bottom: 2px; }
.fd-price { font-size: 1.5rem; font-weight: 900; color: var(--color-primary); }

/* Add-ons chips */
.fd-addons { margin-bottom: 14px; }
.fd-addon-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.fd-addon-chip {
  cursor: pointer;
  display: block;
}
.fd-addon-chip input { display: none; }
.fd-addon-inner {
  display: flex;
  align-items: center;
  gap: 6px;
  border: 1.5px solid var(--color-border);
  border-radius: var(--radius-sm);
  padding: 7px 12px;
  font-size: .8rem;
  background: var(--color-bg-soft);
  transition: all .15s;
  cursor: pointer;
}
.fd-addon-chip input:checked + .fd-addon-inner {
  border-color: var(--color-primary);
  background: var(--color-accent);
  color: var(--color-primary-dark);
}
.fd-addon-name { font-weight: 600; color: var(--color-text); }
.fd-addon-price { font-size: .75rem; color: var(--color-text-muted); }

/* CTA button */
.fd-btn-add {
  display: block;
  width: 100%;
  background: var(--color-primary);
  color: #fff;
  border: none;
  border-radius: var(--radius-pill);
  padding: 13px;
  font-size: .95rem;
  font-weight: 800;
  text-align: center;
  cursor: pointer;
  transition: background .2s, transform .15s;
  text-decoration: none;
  margin-top: auto;
}
.fd-btn-add:hover { background: var(--color-primary-dark); color: #fff; transform: translateY(-1px); }

/* Reviews card */
.fd-reviews-card {
  background: #fff;
  border-radius: 20px;
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-card);
  padding: 24px 28px;
}
.fd-reviews-title {
  font-size: 1.05rem;
  font-weight: 800;
  color: var(--color-text);
  margin-bottom: 16px;
}
.fd-reviews-body {
  display: flex;
  gap: 32px;
  align-items: center;
  margin-bottom: 14px;
}
.fd-score-block { text-align: center; }
.fd-score-num { font-size: 3rem; font-weight: 900; color: var(--color-primary); line-height: 1; }
.fd-score-stars { display: flex; gap: 2px; justify-content: center; margin: 4px 0; }
.fd-score-lbl { font-size: .72rem; color: var(--color-text-muted); font-weight: 600; }
.fd-bar-block { flex: 1; display: flex; flex-direction: column; gap: 5px; }
.fd-bar-row { display: flex; align-items: center; gap: 8px; }
.fd-bar-lbl { font-size: .78rem; font-weight: 600; color: var(--color-text-muted); width: 22px; text-align: right; flex-shrink: 0; }
.fd-bar-track { flex: 1; height: 8px; background: var(--color-bg-soft); border-radius: 50px; overflow: hidden; }
.fd-bar-fill { height: 100%; background: var(--color-primary); border-radius: 50px; transition: width .4s ease; }
.fd-bar-pct { font-size: .72rem; color: var(--color-text-muted); width: 28px; }
.fd-reviews-note { font-size: .8rem; color: var(--color-text-muted); margin: 0; }

@media (max-width: 768px) {
  .fd-card { flex-direction: column; }
  .fd-img-col { width: 100%; }
  .fd-img { height: 200px; }
  .fd-reviews-body { flex-direction: column; gap: 16px; align-items: flex-start; }
}
</style>

<script>
function changeQty(delta) {
  var input = document.getElementById('qtyInput');
  var val = parseInt(input.value) + delta;
  if (val >= 1 && val <= 20) input.value = val;
}
</script>

<jsp:include page="footer.jsp" />
