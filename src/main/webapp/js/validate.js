// ============================================================
// FoodOrder — Client-side form validation
// ============================================================

(function () {
  function markInvalid(input) {
    input.classList.add('is-invalid');
  }
  function clearInvalid(input) {
    input.classList.remove('is-invalid');
  }

  // Generic Bootstrap-style validation for forms with novalidate
  // (contactForm has its own dedicated handler below, so it's excluded here)
  document.querySelectorAll('form[novalidate]:not(#contactForm)').forEach(function (form) {
    form.addEventListener('submit', function (e) {
      let valid = true;
      form.querySelectorAll('input[required], select[required], textarea[required]').forEach(function (input) {
        if (!input.value.trim()) {
          markInvalid(input);
          valid = false;
        } else {
          clearInvalid(input);
        }
      });

      // Email fields
      form.querySelectorAll('input[type="email"]').forEach(function (input) {
        const emailPattern = /^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$/;
        if (input.value && !emailPattern.test(input.value)) {
          markInvalid(input);
          valid = false;
        }
      });

      // Password confirmation (registration form)
      const password = form.querySelector('#password');
      const confirmPassword = form.querySelector('#confirmPassword');
      if (password && confirmPassword && password.value !== confirmPassword.value) {
        markInvalid(confirmPassword);
        valid = false;
      }

      // Password strength (registration form only — identified by the
      // presence of #confirmPassword, so the login form's password field
      // is never subjected to this rule)
      if (password && confirmPassword) {
        const strongPasswordPattern = /^(?=.*[A-Za-z])(?=.*\d).{8,}$/;
        if (password.value && !strongPasswordPattern.test(password.value)) {
          markInvalid(password);
          valid = false;
        }
      }

      if (!valid) {
        e.preventDefault();
      }
    });

    form.querySelectorAll('input, select, textarea').forEach(function (input) {
      input.addEventListener('input', function () { clearInvalid(input); });
    });
  });

  // Contact form — client-side validation only; a valid submit posts to /contact
  const contactForm = document.getElementById('contactForm');
  if (contactForm) {
    const emailPattern = /^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$/;
    const loginAlert = document.getElementById('contactLoginAlert');
    contactForm.addEventListener('submit', function (e) {
      if (contactForm.dataset.loggedIn !== 'true') {
        e.preventDefault();
        if (loginAlert) {
          loginAlert.classList.remove('d-none');
          loginAlert.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return;
      }
      let valid = true;
      ['contactName', 'contactEmail', 'contactSubject', 'contactMessage'].forEach(function (id) {
        const el = document.getElementById(id);
        if (!el.value.trim()) { markInvalid(el); valid = false; } else { clearInvalid(el); }
      });
      const emailEl = document.getElementById('contactEmail');
      if (emailEl.value.trim() && !emailPattern.test(emailEl.value.trim())) {
        markInvalid(emailEl);
        valid = false;
      }
      if (!valid) {
        e.preventDefault();
      }
    });
  }

  // Quantity input min enforcement
  document.querySelectorAll('input[type="number"][name="quantity"]').forEach(function (input) {
    input.addEventListener('change', function () {
      const min = parseInt(input.min || '0', 10);
      if (parseInt(input.value, 10) < min) input.value = min;
    });
  });
})();
