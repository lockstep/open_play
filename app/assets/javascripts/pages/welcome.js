// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  var $datepicker = $('#datepicker');
  if ($datepicker.length > 0) {
    // DatePicker
    var currentValue = $datepicker.val();
    var datePicker = new Pikaday({
      field: document.getElementById('datepicker'),
      format: 'D MMM YYYY',
      minDate: moment().toDate()
    });
    var currentMoment = currentValue ? moment(currentValue) : moment();
    datePicker.setDate(currentMoment.toDate());
  }

  // TimePicker
  var timePicker = $('#timepicker')
  var currentTime = timePicker.val();
  var setTime = currentTime ? currentTime : '17:00';
  timePicker.timepicker({ 'scrollDefault': 'now' });
  timePicker.timepicker('setTime', setTime);
});

$(document).on("click", "#discovery-tiles a", function(e) {
  e.preventDefault();
  var activity = $(this).data("activity");
  if(activity) {
    $("#activity_type").val(activity);
    $("#searchbar-container").find("form").submit();
  }
});
