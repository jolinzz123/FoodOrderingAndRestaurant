<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("pageTitle", "Contact Us — HotServe");
    String ctx = request.getContextPath();
%>
<jsp:include page="header.jsp" />

<div class="container py-5">
  <div class="section-title">
    <h2>Contact Us</h2>
    <p>We'd love to hear from you</p>
  </div>

  <div class="row g-5">
    <div class="col-md-5">
      <h5>Reach Us</h5>
      <p class="text-muted">📍 123 Garden Street, Sepang, Selangor, Malaysia</p>
      <p class="text-muted">📞 +60 12-345 6789</p>
      <p class="text-muted">✉️ hello@foodorder.com</p>
      <p class="text-muted">🕒 Mon–Sun, 10:00 AM – 10:00 PM</p>
    </div>
    <div class="col-md-7">
      <div id="contactSuccess" class="alert alert-success d-none">Thanks for reaching out! We'll reply within 1–2 business days.</div>
      <form id="contactForm" novalidate>
        <div class="row g-3">
          <div class="col-md-6">
            <label class="form-label">Name</label>
            <input type="text" class="form-control" id="contactName" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">Email</label>
            <input type="email" class="form-control" id="contactEmail" required>
          </div>
          <div class="col-12">
            <label class="form-label">Subject</label>
            <input type="text" class="form-control" id="contactSubject" required>
          </div>
          <div class="col-12">
            <label class="form-label">Message</label>
            <textarea class="form-control" id="contactMessage" rows="5" required></textarea>
          </div>
          <div class="col-12">
            <button type="submit" class="btn btn-brand">Send Message</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
