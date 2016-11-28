$(function() {
  if ($('#rate-date-picker').length > 0) {
    var datePicker = new Pikaday({
      field: document.getElementById('rate-date-picker'),
      format: 'D MMM YYYY',
      minDate: moment().toDate()
    });
    datePicker.setDate(moment().toDate());

    var start_time = $('#overriding_begins_at')
    start_time.timepicker({ 'scrollDefault': 'now' });
    start_time.timepicker('setTime', '08:00');

    var end_time = $('#overriding_ends_at')
    end_time.timepicker({ 'scrollDefault': 'now' });
    end_time.timepicker('setTime', '09:00');
  }

  $("#rate-specific-day-checkbox, #rate-every-x-checkbox").change(function() {
    $('#overridden-on').toggleClass('rate-override-inactive');
    $('#rate-list-of-days').toggleClass('rate-override-inactive');
  });

  $("#rate-all-day-checkbox, #rate-specific-time-range-checkbox").change(function() {
    $('#rate-range').toggleClass('rate-override-inactive');
  });

  $("#rate-all-reservable-checkbox, #rate-specific-reservable-checkbox").change(function() {
    $('#rate-list-of-reservables').toggleClass('rate-override-inactive');
  });

  $('#create-rate-override-schedule-btn').click(function(e) {
    e.preventDefault();
    if ($("#rate-specific-day-checkbox").is(":checked")) {
      $('#rate-list-of-days input[type=checkbox]').attr('checked', false); }
    else { $('#rate-date-picker').val(''); }

    if ($("#rate-all-day-checkbox").is(":checked")) {
      $('#overriding_begins_at, #overriding_ends_at').val('');
    }

    if ($("#rate-all-reservable-checkbox").is(":checked")) {
      $('#rate-list-of-reservables input[type=checkbox]').attr('checked', false); }

    $('#new-rate-override-form').submit();
  });
});
