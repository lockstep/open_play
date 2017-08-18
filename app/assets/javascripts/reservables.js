$(function() {
  if ($('#new_reservable').length > 0) {
    var reservableStartTime = $('#reservable_start_time');
    reservableStartTime.timepicker({ 'scrollDefault': 'now' });
    reservableStartTime.timepicker('setTime', '08:00');

    var reservableEndTime = $('#reservable_end_time');
    reservableEndTime.timepicker({ 'scrollDefault': 'now' });
    reservableEndTime.timepicker('setTime', '16:00');

    $('.form-check-input').change(function() {
      var $row = $(this).closest('.row');
      var $priorityNumberField = $row.find('select');
      $priorityNumberField.prop('disabled', !this.checked)
    });
  };

  if ($('#edit_reservable').length > 0) {
    $('#reservable_start_time').timepicker({ 'scrollDefault': 'now' });
    $('#reservable_end_time').timepicker({ 'scrollDefault': 'now' });
  };

});
