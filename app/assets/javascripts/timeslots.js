// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {

  Utilities.preventBackToBackBooking();
  Utilities.slidingSlot();

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

  $('.activity-info').on('click', '.timeslot', function() {
    var activityId = $(this).data('activity-id');
    var reservableId = $(this).data('reservable-id');
    var slot = $(this).data('slot');
    var icon = $(this).find('i');

    showHideCheckIcon(icon);
    toggleCheckBox(activityId, reservableId, slot);
    preventBackToBackBooking(activityId, reservableId, slot);
  });

});

var Utilities = {
  // To prevent back-to-back bookings if a current user tries to book them by
  // searching again.
  preventBackToBackBooking: function(){
    $('.activity-result').each(function(index, activity) {
      var preventBackToBack = $(activity).find("input[name|='prevent-btb-booking']");
      if (preventBackToBack.val() == 'true') {
        $(activity).find('.current-user-booked-slot').each(function(index, slot) {
          // Have to wrap the slot with a div due to using slick.js
          slot_parent = $(slot).parent();
          $(slot_parent).next().children('button').prop('disabled', true);
          $(slot_parent).prev().children('button').prop('disabled', true);
        });
      }
    });
  },
  slidingSlot: function(){
    $('.row-times').not('.slick-initialized').slick({
      slidesToShow: 7,
      slidesToScroll: 1,
      arrows: true,
      infinite: false,
      speed: 200,
      responsive    : [
        {
          breakpoint: 1100,
          settings  : {
              slidesToShow  : 6
          }
        },
        {
          breakpoint: 990,
          settings  : {
              slidesToShow  : 5
          }
        },
        {
          breakpoint: 770,
          settings  : {
              slidesToShow  : 3
          }
        }

      ]
    });
  }
}
