// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(() => {

  const showHideCheckIcon = icon => {
    if (icon.hasClass('fa-check')) {
      icon.removeClass('fa-check')
    } else {
      icon.addClass('fa-check')
    }
  };

  const toggleCheckBox = (activityId, reservableId, slot) => {
    const checkboxName = `#${activityId}-${reservableId}-${slot}`;
    $(checkboxName).prop('checked', (i, value) => !value);
  };

  $('.timeslot').on('click', function() {
    const activityId = $(this).data('activity-id');
    const reservableId = $(this).data('reservable-id');
    const slot = $(this).data('slot');
    const icon = $(this).find('i');

    showHideCheckIcon(icon);
    toggleCheckBox(activityId, reservableId, slot);
  });
});
