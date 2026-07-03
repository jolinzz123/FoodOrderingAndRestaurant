    </main>
  </div><!-- /adm-content -->
</div><!-- /admin-layout -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.querySelectorAll('.adm-row-clickable').forEach(function (row) {
    row.addEventListener('click', function (e) {
      if (e.target.closest('a, button')) return;
      if (row.dataset.modalTarget) {
        var modalEl = document.querySelector(row.dataset.modalTarget);
        if (modalEl) new bootstrap.Modal(modalEl).show();
      } else if (row.dataset.href) {
        window.location.href = row.dataset.href;
      }
    });
  });
</script>
</body>
</html>
