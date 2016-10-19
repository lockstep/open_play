$(function() {
  if ($('#reservations-booking-date').length > 0) {
    var datePicker = new Pikaday({
      field: document.getElementById('reservations-booking-date')
    });

    $('#reservations-booking-date').on('change', function() {
      $('#orders-reservations-form').submit()
    });
  }
});
