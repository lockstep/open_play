// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {

  var showHideCheckIcon = function(icon) {
    if (icon.hasClass('fa-check')) {
      icon.removeClass('fa-check')
    } else {
      icon.addClass('fa-check')
    }
  };

  var toggleCheckBox = function(activityId, reservableId, slot) {
    var checkboxName = '#' + activityId + '-' + reservableId + '-' + slot;
    $(checkboxName).prop('checked', function(i, value) { return !value; });
  };

  $('.timeslot').on('click', function() {
    var element = $(this);
    var activityId = element.data('activity-id');
    var reservableId = element.data('reservable-id');
    var slot = element.data('slot');
    var icon = element.find('i');

    showHideCheckIcon(icon);
    toggleCheckBox(activityId, reservableId, slot);
  });
});
