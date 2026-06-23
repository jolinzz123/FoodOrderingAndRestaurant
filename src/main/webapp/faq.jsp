<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("pageTitle", "FAQ — FoodOrder");
    String ctx = request.getContextPath();
%>
<jsp:include page="header.jsp" />

<div class="container py-5">
  <div class="section-title">
    <h2>Frequently Asked Questions</h2>
  </div>

  <div class="accordion" id="faqAccordion" style="max-width:760px; margin:0 auto;">
    <div class="accordion-item">
      <h2 class="accordion-header"><button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">How do I place an order?</button></h2>
      <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
        <div class="accordion-body">Browse the Menu page, choose a dish, select your quantity and add-ons, then add it to your cart. Once you're ready, go to your cart and proceed to checkout. You'll need to be logged in to place an order.</div>
      </div>
    </div>
    <div class="accordion-item">
      <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">Do I need an account to browse the menu?</button></h2>
      <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
        <div class="accordion-body">No — anyone can browse the menu and view food details. You only need to register and log in when you're ready to order.</div>
      </div>
    </div>
    <div class="accordion-item">
      <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">What payment methods are supported?</button></h2>
      <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
        <div class="accordion-body">Cash on delivery, credit/debit card, and e-wallet options are available at checkout.</div>
      </div>
    </div>
    <div class="accordion-item">
      <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq4">Can I edit or cancel my order after checkout?</button></h2>
      <div id="faq4" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
        <div class="accordion-body">Once placed, orders move into our kitchen queue and can't be edited directly. Please contact us promptly if you need to cancel.</div>
      </div>
    </div>
    <div class="accordion-item">
      <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq5">How are ratings calculated?</button></h2>
      <div id="faq5" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
        <div class="accordion-body">Each dish's rating reflects aggregated feedback from customers who have ordered and reviewed it.</div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
