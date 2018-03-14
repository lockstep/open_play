$(function() {
  // Reload admin reserver so staff can work simultaneously
  if($('.activity-list__admin').length > 0) {
    var intervalId = window.setInterval(reserverResetFunction, 15000);
    function reserverResetFunction() {
      if($('.activity-list__admin').length === 0) clearInterval(intervalId);
      if($('.timeslot.selected').length == 0) {
        clearInterval(intervalId);
        location.reload();
      }
    }
  }

  if ($('#closed_on').length > 0) {
    var datePicker = new Pikaday({
      field: document.getElementById('closed_on'),
      format: 'D MMM YYYY',
      minDate: moment().toDate()
    });
    datePicker.setDate(moment().toDate());

    var closingStartTime = $('#closing_begins_at')
    closingStartTime.timepicker({ 'scrollDefault': 'now' });
    closingStartTime.timepicker('setTime', '08:00');

    var closingEndTime = $('#closing_ends_at')
    closingEndTime.timepicker({ 'scrollDefault': 'now' });
    closingEndTime.timepicker('setTime', '09:00');
  }

  $("#specific-day-checkbox, #every-x-checkbox").change(function() {
    $('#closed-on').toggleClass('closing-time-inactive');
    $('#list-of-days').toggleClass('closing-time-inactive');
  });

  $("#all-day-checkbox, #specific-time-range-checkbox").change(function() {
    $('#closing-time-range').toggleClass('closing-time-inactive');
  });

  $("#all-reservable-checkbox, #specific-reservable-checkbox").change(function() {
    $('#list-of-reservables').toggleClass('closing-time-inactive');
  });

  $('#create-schedule-btn').click(function(e) {
    e.preventDefault();
    if ($("#specific-day-checkbox").is(":checked")) {
      $('#list-of-days input[type=checkbox]').attr('checked', false);
    } else {
      $('#closed_on').val('');
    }

    if ($("#all-day-checkbox").is(":checked")) {
      $('#closing_begins_at, #closing_ends_at').val('');
    }

    if ($("#all-reservable-checkbox").is(":checked")) {
      $('#list-of-reservables input[type=checkbox]').attr('checked', false);
    }

    $('#new-closing-time-form').submit();
  });

  if ($('#new_activity').length > 0) {
    var activityStartTime = $('#activity_start_time');
    activityStartTime.timepicker({ 'scrollDefault': 'now' });
    activityStartTime.timepicker('setTime', '08:00');

    var activityEndTime = $('#activity_end_time');
    activityEndTime.timepicker({ 'scrollDefault': 'now' });
    activityEndTime.timepicker('setTime', '16:00');
  }

  if ($('#edit_activity').length > 0) {
    $('#activity_start_time').timepicker({ 'scrollDefault': 'now' });
    $('#activity_end_time').timepicker({ 'scrollDefault': 'now' });
  }

});
