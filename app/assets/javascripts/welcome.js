// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  if ($('#datepicker').length > 0) {
    // DatePicker
    var datePicker = new Pikaday({
      field: document.getElementById('datepicker'),
      format: 'D MMM YYYY',
      minDate: moment().toDate()
    });
    datePicker.setDate(moment().toDate());
  }

  // TimePicker
  var timePicker = $('#timepicker')
  timePicker.timepicker({ 'scrollDefault': 'now' });
  timePicker.timepicker('setTime', '11:00');
});
