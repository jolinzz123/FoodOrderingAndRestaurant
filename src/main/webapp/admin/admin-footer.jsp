    </main>
  </div><!-- /adm-content -->
</div><!-- /admin-layout -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.querySelectorAll('.adm-row-clickable').forEach(function (row) {
    row.addEventListener('click', function (e) {
      if (e.target.closest('a, button')) return;
      window.location.href = row.dataset.href;
    });
  });
</script>
</body>
</html>
