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
  timePicker.timepicker('setTime', '17:00');
});

$(document).on("click", "#discovery-tiles a", function(e) {
  e.preventDefault();
  var activity = $(this).data("activity");
  if(activity) {
    $("#activity_type").val(activity);
    $("#searchbar-container").find("form").submit();
  }
});
