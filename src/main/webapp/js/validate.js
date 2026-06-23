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
  document.querySelectorAll('form[novalidate]').forEach(function (form) {
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

      if (!valid) {
        e.preventDefault();
      }
    });

    form.querySelectorAll('input, select, textarea').forEach(function (input) {
      input.addEventListener('input', function () { clearInvalid(input); });
    });
  });

  // Contact form (no backend — demo client-side only)
  const contactForm = document.getElementById('contactForm');
  if (contactForm) {
    contactForm.addEventListener('submit', function (e) {
      e.preventDefault();
      let valid = true;
      ['contactName', 'contactEmail', 'contactSubject', 'contactMessage'].forEach(function (id) {
        const el = document.getElementById(id);
        if (!el.value.trim()) { markInvalid(el); valid = false; } else { clearInvalid(el); }
      });
      if (valid) {
        document.getElementById('contactSuccess').classList.remove('d-none');
        contactForm.reset();
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
