$(function() {
  if ($('#reservations-booking-date').length > 0) {
    var datePicker = new Pikaday({
      field: document.getElementById('reservations-booking-date'),
      format: 'D MMM YYYY'
    });
    $('#reservations-booking-date').on('change', function() {
      $('#orders-reservations-form').submit()
    });
  }
});
