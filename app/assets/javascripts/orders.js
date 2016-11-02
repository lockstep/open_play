$(function() {
  var renderReservationErrors = function(errors) {
    $("<div id='bookings-errors' class='alert alert-danger' role='alert'><ul></ul></div>")
      .insertBefore('#order-date');
    errors.forEach(function(error) {
      $('#bookings-errors ul').append("<li role='menu-item'>" + error + "</li>")
    })
  };

  var renderFieldErrorInGuestForm = function($field, name) {
    if(!$field.parent().hasClass('has-danger')) {
      $field.parent().addClass('has-danger');
      $field.addClass('form-control-danger');
      $("<div class='form-control-feedback'>" + name + "</div>").insertAfter($field);
    }
  };

  var hasRequireFieldError = function($field, column_name) {
    if ($field.val() === "") {
      renderFieldErrorInGuestForm($field, column_name + ' is required');
      return true;
    } else {
      return false;
    }
  };

  var hasEmailError = function($field) {
    if (!validateEmail($field.val())) {
      renderFieldErrorInGuestForm($field, 'Email is invalid');
      return true;
    } else {
      return false;
    }
  };

  var validateEmail = function(email) {
    var regx = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return regx.test(email);
  }

  var validGuestForm = function() {
    var have_errors = false;
    var $firstName = $('#first-name-order');
    var $lastName = $('#last-name-order');
    var $email = $('#email-order');
    if (!hasRequireFieldError($firstName, 'First name') &&
      !hasRequireFieldError($lastName, 'Last name') &&
      !hasRequireFieldError($email, 'Email') && !hasEmailError($email) ) {
      return true;
    } else {
      return false;
    }
  };

  var transferGuestFormToOrderForm = function() {
    $('#order_guest_first_name').val($('#first-name-order').val());
    $('#order_guest_last_name').val($('#last-name-order').val());
    $('#order_guest_email').val($('#email-order').val());
  };

  var clearFieldInForm = function($field) {
    if($field.parent().hasClass('has-danger')) {
      $field.parent().removeClass('has-danger');
      $field.removeClass('form-control-danger');
      $field.next().remove();
    }
  }

  var clearGuestForm = function() {
    clearFieldInForm($('#first-name-order'));
    clearFieldInForm($('#last-name-order'));
    clearFieldInForm($('#email-order'));
  };

  var completeReservation = function() {
    $('#bookings-errors').remove(); // destroy previous errors
    $.ajax({
      url: "/prepare_complete_order",
      type: "GET",
      data: $('#new-order-form').serialize(),
      success: function(response) {
        OPEN_PLAY.checkoutInitiator(
          response.meta.number_of_bookings,
          response.meta.total_price
        );
      },
      error: function(xhr, status, error) {
        renderReservationErrors(xhr.responseJSON.meta.errors)
      }
    });
  };

  $('#user-complete-reservation').click(function(e) {
    e.preventDefault();
    completeReservation();
  });

  $('#guest-complete-reservation').click(function(e) {
    e.preventDefault();
    $('#guest-modal').modal('show');
  });

  $('#submit-order-form').click(function(e) {
    e.preventDefault();
    clearGuestForm();
    if (validGuestForm()) {
      transferGuestFormToOrderForm();
      $('#guest-modal').modal('hide');
      completeReservation();
    }
  });

  window.addEventListener('popstate', function() {
    OPEN_PLAY.checkoutHandler.close();
  });
});


OPEN_PLAY.checkoutInitiator = function(number_of_bookings ,total_price) {
  var unit = number_of_bookings == 1 ? 'booking' : 'bookings';
  OPEN_PLAY.checkoutHandler.open({
    name: 'Open Play',
    description: number_of_bookings + ' ' + unit,
    amount: total_price
  });
}

OPEN_PLAY.successfulChargeCallback = function(token) {
  $('#token_id').val(token.id);
  $('#new-order-form').submit();
}

OPEN_PLAY.checkoutHandler = StripeCheckout.configure({
  key: OPEN_PLAY.stripeKey,
  image: OPEN_PLAY.iconImageUrl,
  locale: 'auto',
  token: OPEN_PLAY.successfulChargeCallback
});
