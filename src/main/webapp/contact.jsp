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
    <div class="col-lg-5">
      <h5 class="mb-3">Reach Us</h5>
      <div class="contact-info-list">
        <a class="contact-info-item contact-info-item--lg contact-info-item--link" href="https://www.google.com/maps/search/?api=1&query=Xiamen+University+Malaysia" target="_blank" rel="noopener">
          <span class="contact-info-icon contact-info-icon--lg"><i class="bi bi-geo-alt-fill"></i></span>
          <span>Xiamen University Malaysia</span>
          <i class="bi bi-box-arrow-up-right contact-info-arrow"></i>
        </a>
        <a class="contact-info-item contact-info-item--lg contact-info-item--link" href="https://wa.me/60123066789" target="_blank" rel="noopener">
          <span class="contact-info-icon contact-info-icon--lg contact-info-icon--whatsapp"><i class="bi bi-whatsapp"></i></span>
          <span>+60 12-306 6789</span>
          <i class="bi bi-box-arrow-up-right contact-info-arrow"></i>
        </a>
        <a class="contact-info-item contact-info-item--lg contact-info-item--link" href="mailto:contact@hotserve.com">
          <span class="contact-info-icon contact-info-icon--lg"><i class="bi bi-envelope-fill"></i></span>
          <span>contact@hotserve.com</span>
          <i class="bi bi-box-arrow-up-right contact-info-arrow"></i>
        </a>
        <div class="contact-info-item contact-info-item--lg">
          <span class="contact-info-icon contact-info-icon--lg"><i class="bi bi-clock-fill"></i></span>
          <span>Mon–Sun, 10:00 AM – 10:00 PM</span>
        </div>
      </div>
    </div>
    <div class="col-lg-7">
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
            <button type="submit" class="btn btn-brand w-100">Send Message</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
