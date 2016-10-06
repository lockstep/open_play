// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(() => {
  // DatePicker
  const datePicker = new Pikaday({
    field: document.getElementById('datepicker'),
    format: 'D/M/YYYY',
    minDate: moment().toDate()
  });
  datePicker.setDate(moment().toDate());

  // TimePicker
  const timePicker = $('#timepicker');
  timePicker.timepicker({ 'scrollDefault': 'now' });
  timePicker.timepicker('setTime', new Date());
});
