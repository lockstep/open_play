$(function() {
  if ($('#order_filter_from_date').length > 0) {
    var fromDate = new Pikaday({
      field: document.getElementById('order_filter_from_date'),
      format: 'D MMM YYYY'
    });
  }

  if ($('#order_filter_to_date').length > 0) {
    var toDate = new Pikaday({
      field: document.getElementById('order_filter_to_date'),
      format: 'D MMM YYYY'
    });
  }
});
