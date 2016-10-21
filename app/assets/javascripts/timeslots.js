// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {

  var showHideCheckIcon = function(icon) {
    icon.hasClass('fa-check') ? icon.removeClass('fa-check') : icon.addClass('fa-check')
  };

  var toggleCheckBox = function(activityId, reservableId, slot) {
    var checkboxName = '#' + activityId + '-' + reservableId + '-' + slot;
    $(checkboxName).prop('checked', function(i, value) { return !value; });
  };

  var preventBackToBackBooking = function(activityId, reservableId, slotNo) {
    if ($('#prevent-btb-booking-' + activityId).val() == 'false') return;
    var timeslotId = '#timeslot-' + activityId + '-' + reservableId + '-';
    var selectedSlot = $(timeslotId + slotNo)

    // back-to-back slots
    var leftSlot1 = $(timeslotId + (slotNo-1));
    var rightSlot1 = $(timeslotId + (slotNo+1));

    var leftSlot2 = $(timeslotId + (slotNo-2));
    var rightSlot2 = $(timeslotId + (slotNo+2));

    if (isBooked(selectedSlot)) {
      leftSlot1.prop('disabled', true);
      rightSlot1.prop('disabled', true);
    } else {
      if (!isBooked(leftSlot2)) leftSlot1.prop('disabled', false);
      if (!isBooked(rightSlot2)) rightSlot1.prop('disabled', false);
    }
  };

  var isBooked = function(slot) {
    return slot.find('i').hasClass('fa-check')
  };

  $('.timeslot').on('click', function() {
    var activityId = $(this).data('activity-id');
    var reservableId = $(this).data('reservable-id');
    var slot = $(this).data('slot');
    var icon = $(this).find('i');

    showHideCheckIcon(icon);
    toggleCheckBox(activityId, reservableId, slot);
    preventBackToBackBooking(activityId, reservableId, slot);
  });

});
