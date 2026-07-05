<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodorder.model.FoodItem, com.foodorder.model.User, com.foodorder.model.Addon, com.foodorder.model.CartItem, com.foodorder.model.Review, java.util.List, java.util.Map" %>
<%
    FoodItem item = (FoodItem) request.getAttribute("item");
    request.setAttribute("pageTitle", item.getName() + " — HotServe");
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
    User currentUser = (User) session.getAttribute("user");
    @SuppressWarnings("unchecked")
    List<Addon> addons = (List<Addon>) request.getAttribute("addons");
    @SuppressWarnings("unchecked")
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    @SuppressWarnings("unchecked")
    List<FoodItem> related = (List<FoodItem>) request.getAttribute("related");
    double avgRating = request.getAttribute("avgRating") != null ? (double) request.getAttribute("avgRating") : item.getRating();
    int reviewCount = request.getAttribute("reviewCount") != null ? (int) request.getAttribute("reviewCount") : 0;
    int[] ratingDist = request.getAttribute("ratingDist") != null ? (int[]) request.getAttribute("ratingDist") : new int[6];
    if (reviews == null) reviews = java.util.Collections.emptyList();
    if (related == null) related = java.util.Collections.emptyList();

    // Edit mode: pre-select add-ons from existing cart entry
    String editKey = request.getParameter("editKey");
    java.util.Set<Integer> preselectedAddonIds = new java.util.HashSet<>();
    if (editKey != null && !editKey.isEmpty()) {
        @SuppressWarnings("unchecked")
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart != null) {
            CartItem editing = cart.get(editKey);
            if (editing != null && editing.getSelectedAddonIds() != null) {
                preselectedAddonIds.addAll(editing.getSelectedAddonIds());
            }
        }
    }

    // Star rendering helper — only use real reviews, ignore seeded food_items.rating
    double displayRating = reviewCount > 0 ? avgRating : 0;
    int fullStars = (int) displayRating;
    boolean halfStar = (displayRating - fullStars) >= 0.5;

    // Bar chart percentages (real data)
    int maxDist = 1;
    for (int i = 1; i <= 5; i++) if (ratingDist[i] > maxDist) maxDist = ratingDist[i];
%>
<jsp:include page="header.jsp" />

<div class="fd-page">
  <div class="fd-back-row">
    <a href="<%= ctx %>/menu">← Back to Menu</a>
    <div class="fd-action-btns">
      <button class="fd-icon-btn" id="favBtn" onclick="toggleFav(<%= item.getId() %>)" title="Add to Favourites">
        <span id="favIcon">♡</span>
      </button>
      <button class="fd-icon-btn" onclick="shareItem()" title="Share">
        <span>🔗</span>
      </button>
    </div>
  </div>
  <div id="shareToast" class="fd-toast">Link copied to clipboard!</div>

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
        <span class="fd-cat-badge"><%= item.getCategoryName() != null ? item.getCategoryName() : "Uncategorized" %></span>
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
          <% if (reviewCount > 0) { %>
          <span class="fd-rating-num"><%= String.format("%.1f", displayRating) %></span>
          <span class="fd-rating-lbl">(<%= reviewCount %> review<%= reviewCount != 1 ? "s" : "" %>)</span>
          <% } else { %>
          <span class="fd-rating-lbl" style="color:var(--color-text-muted)">No ratings yet</span>
          <% } %>
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
        <input type="hidden" name="returnTo" value="<%= (editKey != null && !editKey.isEmpty()) ? "/cart" : "/menu" %>">
        <% if (editKey != null && !editKey.isEmpty()) { %>
        <input type="hidden" name="editKey" value="<%= editKey %>">
        <% } %>

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
              <input type="checkbox" name="addons" value="<%= a.getId() %>"
                     <%= preselectedAddonIds.contains(a.getId()) ? "checked" : "" %>>
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
          <button type="submit" class="fd-btn-add">
            <%= editKey != null && !editKey.isEmpty() ? "Update Order" : "Add to Cart" %>
          </button>
        <% } else { %>
          <a href="<%= ctx %>/login.jsp" class="fd-btn-add">Log in to Order</a>
        <% } %>
      </form>

    </div><!-- end info col -->
  </div><!-- end fd-card -->

  <!-- Ratings & Reviews card -->
  <div class="fd-reviews-card">
    <h5 class="fd-reviews-title">Ratings &amp; Reviews
      <span class="fd-review-count"><%= reviewCount %> review<%= reviewCount != 1 ? "s" : "" %></span>
    </h5>
    <div class="fd-reviews-body">
      <!-- Big score -->
      <div class="fd-score-block">
        <% if (reviewCount > 0) { %>
      <div class="fd-score-num"><%= String.format("%.1f", avgRating) %></div>
      <% } else { %>
      <div class="fd-score-num" style="font-size:1.1rem;color:var(--color-text-muted);line-height:1.3">No<br>ratings</div>
      <% } %>
        <div class="fd-score-stars">
          <% for (int s = 1; s <= 5; s++) {
              if (s <= fullStars) { %><span class="fd-star filled">★</span><%
              } else if (s == fullStars + 1 && halfStar) { %><span class="fd-star half">★</span><%
              } else { %><span class="fd-star empty">★</span><% }
          } %>
        </div>
        <div class="fd-score-lbl">out of 5</div>
      </div>
      <!-- Real bar chart -->
      <div class="fd-bar-block">
        <% for (int b = 5; b >= 1; b--) {
             int cnt = ratingDist[b];
             int pct = reviewCount > 0 ? (cnt * 100 / reviewCount) : 0;
        %>
        <div class="fd-bar-row">
          <span class="fd-bar-lbl"><%= b %>★</span>
          <div class="fd-bar-track">
            <div class="fd-bar-fill" style="width:<%= pct %>%"></div>
          </div>
          <span class="fd-bar-pct"><%= cnt %></span>
        </div>
        <% } %>
      </div>
    </div>

    <!-- Review list -->
    <% if (!reviews.isEmpty()) { %>
    <div class="fd-review-list">
      <% for (Review rv : reviews) { %>
      <div class="fd-review-item">
        <div class="fd-review-header">
          <span class="fd-review-user">
            <span class="fd-review-avatar"><%= rv.getUsername() != null ? rv.getUsername().substring(0,1).toUpperCase() : "?" %></span>
            <%= rv.getUsername() %>
          </span>
          <span class="fd-review-stars">
            <% for (int s = 1; s <= 5; s++) { %>
              <span class="fd-star <%= s <= rv.getRating() ? "filled" : "empty" %>">★</span>
            <% } %>
          </span>
          <span class="fd-review-date">
            <% if (rv.getCreatedAt() != null) {
                 java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("d MMM yyyy");
            %>
            <%= sdf.format(rv.getCreatedAt()) %>
            <% } %>
          </span>
        </div>
        <% if (rv.getComment() != null && !rv.getComment().isEmpty()) { %>
        <div class="fd-review-comment"><%= rv.getComment() %></div>
        <% } %>
      </div>
      <% } %>
    </div>
    <% } else { %>
    <p class="fd-reviews-note">No reviews yet. Be the first to share your experience after placing an order!</p>
    <% } %>
  </div>

  <!-- You may also like -->
  <% if (!related.isEmpty()) { %>
  <div class="fd-related-section">
    <h5 class="fd-related-title">You may also like</h5>
    <div class="fd-related-grid">
      <% for (FoodItem rel : related) {
           double relRating = rel.getRating();
           int relFull = (int) relRating;
           boolean relHalf = (relRating - relFull) >= 0.5;
      %>
      <a href="<%= ctx %>/food?id=<%= rel.getId() %>" class="fd-rel-card">
        <img src="<%= ctx %>/<%= rel.getImageUrl() %>"
             alt="<%= rel.getName() %>"
             class="fd-rel-img"
             onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=70'">
        <div class="fd-rel-body">
          <div class="fd-rel-name"><%= rel.getName() %></div>
          <div class="fd-rel-row">
            <div class="fd-rel-stars">
              <% for (int s = 1; s <= 5; s++) { %>
                <span class="fd-star <%= s <= relFull ? "filled" : (s == relFull+1 && relHalf ? "half" : "empty") %>" style="font-size:.75rem">★</span>
              <% } %>
            </div>
            <div class="fd-rel-price">RM <%= String.format("%.2f", rel.getPrice()) %></div>
          </div>
        </div>
      </a>
      <% } %>
    </div>
  </div>
  <% } %>

</div><!-- end fd-page -->

<style>
.fd-page {
  max-width: 980px;
  margin: 0 auto;
  padding: 28px 20px 60px;
}
.fd-back-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 18px;
}
.fd-back-row a {
  font-size: .85rem;
  color: var(--color-text-muted);
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}
.fd-back-row a:hover { color: var(--color-primary); }
.fd-action-btns { display: flex; gap: 8px; }
.fd-icon-btn {
  width: 38px; height: 38px;
  border-radius: 50%;
  border: 1.5px solid var(--color-border);
  background: #fff;
  cursor: pointer;
  font-size: 1.1rem;
  display: flex; align-items: center; justify-content: center;
  transition: all .15s;
  color: var(--color-text);
}
.fd-icon-btn:hover { border-color: var(--color-primary); background: var(--color-accent); }
.fd-icon-btn.fav-active { border-color: #e05; background: #fff0f3; }
.fd-icon-btn.fav-active #favIcon { color: #e05; }

/* Toast */
.fd-toast {
  position: fixed;
  bottom: 32px;
  left: 50%;
  transform: translateX(-50%) translateY(80px);
  background: #333;
  color: #fff;
  border-radius: 50px;
  padding: 10px 22px;
  font-size: .85rem;
  font-weight: 600;
  z-index: 9999;
  transition: transform .3s ease, opacity .3s ease;
  opacity: 0;
  pointer-events: none;
}
.fd-toast.show { transform: translateX(-50%) translateY(0); opacity: 1; }

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
  margin-bottom: 24px;
}
.fd-reviews-title {
  font-size: 1.05rem;
  font-weight: 800;
  color: var(--color-text);
  margin-bottom: 16px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.fd-review-count {
  font-size: .78rem;
  font-weight: 600;
  color: var(--color-text-muted);
  background: var(--color-bg-soft);
  border-radius: 50px;
  padding: 2px 10px;
}
.fd-reviews-body {
  display: flex;
  gap: 32px;
  align-items: center;
  margin-bottom: 20px;
}
.fd-score-block { text-align: center; min-width: 80px; }
.fd-score-num { font-size: 3rem; font-weight: 900; color: var(--color-primary); line-height: 1; }
.fd-score-stars { display: flex; gap: 2px; justify-content: center; margin: 4px 0; }
.fd-score-lbl { font-size: .72rem; color: var(--color-text-muted); font-weight: 600; }
.fd-bar-block { flex: 1; display: flex; flex-direction: column; gap: 5px; }
.fd-bar-row { display: flex; align-items: center; gap: 8px; }
.fd-bar-lbl { font-size: .78rem; font-weight: 600; color: var(--color-text-muted); width: 22px; text-align: right; flex-shrink: 0; }
.fd-bar-track { flex: 1; height: 8px; background: var(--color-bg-soft); border-radius: 50px; overflow: hidden; }
.fd-bar-fill { height: 100%; background: var(--color-primary); border-radius: 50px; transition: width .4s ease; }
.fd-bar-pct { font-size: .72rem; color: var(--color-text-muted); width: 24px; text-align: right; }
.fd-reviews-note { font-size: .8rem; color: var(--color-text-muted); margin: 0; }

/* Review list */
.fd-review-list { border-top: 1px solid var(--color-border); padding-top: 16px; display: flex; flex-direction: column; gap: 14px; }
.fd-review-item { padding-bottom: 14px; border-bottom: 1px solid var(--color-border); }
.fd-review-item:last-child { border-bottom: none; padding-bottom: 0; }
.fd-review-header { display: flex; align-items: center; gap: 10px; margin-bottom: 6px; flex-wrap: wrap; }
.fd-review-avatar {
  width: 30px; height: 30px;
  border-radius: 50%;
  background: var(--color-primary);
  color: #fff;
  font-size: .78rem;
  font-weight: 800;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.fd-review-user { display: flex; align-items: center; gap: 7px; font-weight: 700; font-size: .85rem; color: var(--color-text); }
.fd-review-stars { display: flex; gap: 1px; }
.fd-review-date { font-size: .75rem; color: var(--color-text-muted); margin-left: auto; }
.fd-review-comment { font-size: .85rem; color: var(--color-text); line-height: 1.6; }

/* You may also like */
.fd-related-section { }
.fd-related-title {
  font-size: 1.05rem;
  font-weight: 800;
  color: var(--color-text);
  margin-bottom: 14px;
}
.fd-related-grid {
  display: flex;
  gap: 16px;
}
.fd-rel-card {
  flex: 1;
  background: #fff;
  border-radius: 16px;
  border: 1px solid var(--color-border);
  overflow: hidden;
  text-decoration: none;
  transition: box-shadow .2s, transform .2s;
  display: block;
}
.fd-rel-card:hover { box-shadow: var(--shadow-soft); transform: translateY(-2px); }
.fd-rel-img { width: 100%; height: 120px; object-fit: cover; display: block; }
.fd-rel-body { padding: 10px 12px; }
.fd-rel-name { font-size: .88rem; font-weight: 700; color: var(--color-text); margin-bottom: 6px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.fd-rel-row { display: flex; align-items: center; justify-content: space-between; gap: 6px; }
.fd-rel-stars { display: flex; gap: 1px; }
.fd-rel-price { font-size: .82rem; font-weight: 800; color: var(--color-primary); }

@media (max-width: 768px) {
  .fd-card { flex-direction: column; }
  .fd-img-col { width: 100%; }
  .fd-img { height: 200px; }
  .fd-reviews-body { flex-direction: column; gap: 16px; align-items: flex-start; }
  .fd-related-grid { flex-direction: column; }
}
</style>

<script>
function changeQty(delta) {
  var input = document.getElementById('qtyInput');
  var val = parseInt(input.value) + delta;
  if (val >= 1 && val <= 20) input.value = val;
}

// Favourite — localStorage based
var FAV_KEY = 'hs_favs';
function getFavs() {
  try { return JSON.parse(localStorage.getItem(FAV_KEY) || '[]'); } catch(e) { return []; }
}
function toggleFav(foodId) {
  var favs = getFavs();
  var idx = favs.indexOf(foodId);
  if (idx === -1) { favs.push(foodId); } else { favs.splice(idx, 1); }
  localStorage.setItem(FAV_KEY, JSON.stringify(favs));
  updateFavBtn(foodId, favs);
}
function updateFavBtn(foodId, favs) {
  var btn = document.getElementById('favBtn');
  var icon = document.getElementById('favIcon');
  if (!btn) return;
  if (favs.indexOf(foodId) !== -1) {
    btn.classList.add('fav-active');
    icon.textContent = '♥';
    icon.style.color = '#e05';
  } else {
    btn.classList.remove('fav-active');
    icon.textContent = '♡';
    icon.style.color = '';
  }
}
document.addEventListener('DOMContentLoaded', function() {
  updateFavBtn(<%= item.getId() %>, getFavs());
});

// Share — copy URL to clipboard
function shareItem() {
  var url = window.location.href;
  navigator.clipboard.writeText(url).then(function() {
    showToast();
  }).catch(function() {
    // Fallback for older browsers
    var ta = document.createElement('textarea');
    ta.value = url; ta.style.position = 'fixed'; ta.style.opacity = '0';
    document.body.appendChild(ta); ta.select();
    document.execCommand('copy');
    document.body.removeChild(ta);
    showToast();
  });
}
function showToast() {
  var toast = document.getElementById('shareToast');
  toast.classList.add('show');
  setTimeout(function() { toast.classList.remove('show'); }, 2500);
}
</script>

<jsp:include page="footer.jsp" />
