$(function() {
  var renderErrors = function(errors) {
    $("<div id='bookings-errors' class='alert alert-danger' role='alert'><ul></ul></div>")
      .insertBefore('#order-date');
    errors.forEach(function(error) {
      $('#bookings-errors ul').append("<li role='menu-item'>" + error + "</li>")
    })
  }

  $('#complete-reservation').click(function(e) {
    e.preventDefault();
    // destroy errors
    $('#bookings-errors').remove();

    $.ajax({
      url: "/prepare_complete_order",
      type: "GET",
      data: $('#new-order-form').serialize(),
      success: function(response) {
        OPEN_PLAY.checkoutInitiator(
          response.meta.number_of_bookings,
          response.meta.total_price,
          response.meta.email
        );
      },
      error: function(xhr, status, error) {
        renderErrors(xhr.responseJSON.meta.errors)
      }
    });

  });

  window.addEventListener('popstate', function() {
    OPEN_PLAY.checkoutHandler.close();
  });
});


OPEN_PLAY.checkoutInitiator = function(number_of_bookings ,total_price, email) {
  var unit = number_of_bookings == 1 ? 'booking' : 'bookings';
  OPEN_PLAY.checkoutHandler.open({
    name: 'Open Play',
    description: number_of_bookings + ' ' + unit,
    amount: total_price,
    email: email
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