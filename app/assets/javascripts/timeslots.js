// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {

  Utilities.preventBackToBackBooking();
  Utilities.slidingSlot();
  Utilities.showSpinner();

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

  $('.activity-list').on('click', '.add-more-popup-link', function(e) {
    e.preventDefault();
    var activityId = $(this).data('activity-id');
    var reservableId = $(this).data('reservable-id');
    var rightSlot = $(this).data('next-slot');
    $('#timeslot-' + activityId + '-' + reservableId + '-' + rightSlot).click();
  });

  function isSlotDisabled(slot) {
    return slot.is(':disabled');
  }

  function findRightMostBookedSlot(reservleId){
    var buttons = $('#reservable_' + reservleId + ' .timeslot');
    var rightMostSlot = null;
    for(var i=0; i < buttons.length; i++) {
      if (isBooked($(buttons[i]))) {
        rightMostSlot = $(buttons[i]);
      }
    }
    return rightMostSlot;
  }

  function getPopupLink(activityId, reservableId, rightSlot) {
    var link = "<a href='#' class='alert-link add-more-popup-link' data-activity-id='" +
      activityId + "' data-reservable-id='" + reservableId + "' data-next-slot='" +
      rightSlot + "'>here</a>";
    return link;
  }

  function getPopupMessage(activityId, reservableId, rightSlotNumber, totalTime, selectedReservable, interval, $timeslot) {
    var message = "You've selected " + totalTime + " minutes for " + selectedReservable;
    var rightSlotId = 'timeslot-' + activityId + '-' + reservableId + '-' + rightSlotNumber;

    if (!$timeslot.hasClass('selected')) {
      var rightMostBookedSlot = findRightMostBookedSlot(reservableId);
      var rightMostBookedSlotNumber = rightMostBookedSlot.data('slot');
      var nextRightMostBookedSlotNumber = rightMostBookedSlotNumber + 1;
      var nextRightMostBooked = $('#timeslot-' + activityId + '-' + reservableId + '-' + nextRightMostBookedSlotNumber);
      if (isTheLastSlot(reservableId, rightMostBookedSlotNumber) ||
          isSlotDisabled(nextRightMostBooked)) { return message; }
      else {
        var popupLink = getPopupLink(activityId, reservableId, nextRightMostBookedSlotNumber);
        return message +  ", click " + popupLink + " to add " + interval + " more minutes";
      }
    }
    else if (isTheLastSlot(reservableId, rightSlotNumber - 1)) {
      return message;
    }
    else if (isSlotDisabled($('#' + rightSlotId))) {
      return message + '. The next time slot is unavailable.';
    }
    else if (isBooked($('#' + rightSlotId))) {
      return message + '. The next time slot is currently booked.';
    }
    else {
      var popupLink = getPopupLink(activityId, reservableId, rightSlotNumber);
      return message +  ", click " + popupLink + " to add " + interval + " more minutes";
    }
  }

  var calculateTotalTime = function(reservableId, interval) {
    var $selectedCheckboxs = $('#reservable_' + reservableId + ' button.selected');
    return $selectedCheckboxs.length * interval;
  };

  var isBooked = function(slot) {
    return slot.hasClass('selected')
  };

  function isTheLastSlot(reservableId, slotNumber) {
    var buttons = $('#reservable_' + reservableId + ' .timeslot');
    return slotNumber === buttons.length;
  }

  function showHidePopup(activityId, reservableId, totalTime, selectedReservable, interval, rightSlotNumber, $timeslot) {
    var $popup = $('#popup-' + activityId + '-' + reservableId);
    if (!$timeslot.hasClass('selected') && findRightMostBookedSlot(reservableId) === null) {
      // hide popup in case of any timeslots in lane are not selected
      hidePopup(activityId, reservableId);
    }
    else {
      var message = getPopupMessage(activityId, reservableId, rightSlotNumber,
        totalTime, selectedReservable, interval, $timeslot)
      $popup.html(message).show();
    }
  };

  function hidePopup(activityId, reservableId) {
    var $popup = $('#popup-' + activityId + '-' + reservableId);
    $popup.hide();
  }

  $('.activity-list__admin .activity-info').on('click', '.timeslot', function(e) {
    var $timeslot = $(this);
    if ($timeslot.hasClass('not-checked-in') || $timeslot.hasClass('checked-in')) {
      $('.reserver-cancel-link')
        .prop('href', $timeslot.data('cancel-path'))
        .show();
    }
    if ($timeslot.hasClass('not-checked-in')) {
      $('.reserver-checkin-link')
        .prop('href', $timeslot.data('checkin-path'))
        .show();
    }
  });

  $('.activity-info').on('click', '.timeslot', function() {
    var $timeslot = $(this);
    var activityId = $timeslot.data('activity-id');
    var reservableId = $timeslot.data('reservable-id');
    var interval = $timeslot.data('interval');
    var slot = $timeslot.data('slot');
    var rightSlotNumber = slot + 1;
    var selectedReservable = $timeslot.data('selected-reservable');

    // Toggle button color
    if($timeslot.hasClass('selected')) {
      $timeslot.addClass('btn-danger btn-3d');
      $timeslot.removeClass('btn-success selected');
      $('.booking-controls a').hide();
    } else {
      $timeslot.addClass('btn-success selected');
      $timeslot.removeClass('btn-danger btn-3d');
    }

    toggleCheckBox(activityId, reservableId, slot);
    preventBackToBackBooking(activityId, reservableId, slot);
    if ($timeslot.hasClass('slot-available')){
      showHidePopup(
        activityId, reservableId, calculateTotalTime(reservableId, interval),
        selectedReservable, interval, rightSlotNumber, $timeslot
      );
    };
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
      slidesToShow: 8,
      slidesToScroll: 1,
      arrows: true,
      infinite: false,
      speed: 200,
      responsive    : [
        {
          breakpoint: 1600,
          settings  : {
              slidesToShow  : 7
          }
        },
        {
          breakpoint: 1200,
          settings  : {
              slidesToShow  : 6
          }
        },
        {
          breakpoint: 1000,
          settings  : {
              slidesToShow  : 4
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
  },
  showSpinner: function(){
    $('.activity-info').on('click', '.next, .prev', function() {
      $(this).parents('.reservables').addClass('loading');
    });
  },
  hideSpinner: function(){
    $('.reservables').removeClass('loading');
  }
}
