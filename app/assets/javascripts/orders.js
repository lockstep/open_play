$(function() {
  $('#complete-reservation').click(function(e) {
    e.preventDefault();
    // destroy errors
    $('#bookings-errors').remove();

    $.ajax({
      url: "/verify_order",
      type: "get",
      data: $('#new-order-form').serialize(),
      success: function(response) {
        OPEN_PLAY.checkoutInitiator();
      },
      error: function(xhr, status, error) {
        ORDER.renderErrors(xhr.responseJSON.meta.errors)
      }
    });

  });

  window.addEventListener('popstate', function() {
    OPEN_PLAY.checkoutHandler.close();
  });
});

var ORDER = {
  renderErrors: function(errors) {
    var $errorsContainer = $('<div/>')
      .attr('id', 'bookings-errors')
      .attr('role', 'alert')
      .addClass('alert alert-danger')
      .insertBefore('#order-date');
    var $errorsList = $('<ul/>')
      .appendTo($errorsContainer);
    errors.forEach(function(error) {
      $('<li/>')
        .attr('role', 'menu-item')
        .text(error)
        .appendTo($errorsList);
    })
  }
}

OPEN_PLAY.checkoutInitiator = function() {
  OPEN_PLAY.checkoutHandler.open({
    name: 'Open Play',
    description: '2 widgets',
    amount: 2000
  });
}

OPEN_PLAY.successfulChargeCallback = function(token) {
  $('#new-order-form').submit();
  // You can access the token ID with `token.id`.
  // Get the token ID to your server-side code for use.
}

OPEN_PLAY.checkoutHandler = StripeCheckout.configure({
  key: OPEN_PLAY.stripeKey,
  image: OPEN_PLAY.iconImageUrl,
  locale: 'auto',
  token: OPEN_PLAY.successfulChargeCallback
});
