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
      <h5 class="mb-3">Reach Us</h5>
      <div class="contact-info-list">
        <div class="contact-info-item">
          <span class="contact-info-icon"><i class="bi bi-geo-alt-fill"></i></span>
          <span>123 Garden Street, Sepang, Selangor, Malaysia</span>
        </div>
        <a class="contact-info-item" href="https://wa.me/60123456789" target="_blank" rel="noopener">
          <span class="contact-info-icon contact-info-icon--whatsapp"><i class="bi bi-whatsapp"></i></span>
          <span>+60 12-345 6789</span>
        </a>
        <a class="contact-info-item" href="mailto:hello@foodorder.com">
          <span class="contact-info-icon"><i class="bi bi-envelope-fill"></i></span>
          <span>hello@foodorder.com</span>
        </a>
        <div class="contact-info-item">
          <span class="contact-info-icon"><i class="bi bi-clock-fill"></i></span>
          <span>Mon–Sun, 10:00 AM – 10:00 PM</span>
        </div>
      </div>
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
