$(function() {
  $('#complete-reservation').click(function(e) {
    e.preventDefault();
    // destroy errors
    $('#bookings-errors').remove();

    $.ajax({
      url: "/check_payment_requirement",
      type: "GET",
      data: $('#new-order-form').serialize(),
      success: function(response) {
        if(response.meta.is_required == true) {
          prepareCompleteOrder();
        } else {
          $('#new-order-form').submit();
        }
      },
      error: function(xhr, status, error) {
        renderOrderErrors(xhr.responseJSON.meta.errors)
      }
    });
  });

  window.addEventListener('popstate', function() {
    OPEN_PLAY.checkoutHandler.close();
  });

  $('.order-players').on('change keyup', function (e) {
    if (parseInt($(e.target).val(), 10)) {
      getOrderPrices();
    }
  });
});


OPEN_PLAY.checkoutInitiator = function(number_of_bookings, total_price_cents, email) {
  var unit = number_of_bookings == 1 ? 'booking' : 'bookings';
  OPEN_PLAY.checkoutHandler.open({
    name: 'Open Play',
    description: number_of_bookings + ' ' + unit,
    amount: total_price_cents,
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

function prepareCompleteOrder() {
  $.ajax({
    url: "/prepare_complete_order",
    type: "GET",
    data: $('#new-order-form').serialize(),
    success: function(response) {
      OPEN_PLAY.checkoutInitiator(
        response.meta.number_of_bookings,
        response.meta.total_price_cents,
        response.meta.email
      );
    },
    error: function(xhr, status, error) {
      renderOrderErrors(xhr.responseJSON.meta.errors)
    }
  });
}

function getOrderPrices() {
  $.ajax({
    url: '/get_order_prices',
    type: 'get',
    data: $('#new-order-form').serialize(),
    beforeSend: function() {
      $('.order-prices-container').addClass('loading');
    },
    success: function(response) {
      if (response.meta.total_price != '0') {
        $('.subtotal-price').text('$' + response.meta.sub_total_price);
        $('.total-price').text('$' + response.meta.total_price);
      } else {
        $('.total-price').text('-');
      }
    },
    complete: function() {
      $('.order-prices-container').removeClass('loading');
    }
  });
}

function renderOrderErrors(errors) {
  $("<div id='bookings-errors' class='alert alert-danger' role='alert'><ul></ul></div>")
    .insertBefore('#order-date');
  errors.forEach(function(error) {
    $('#bookings-errors ul').append("<li role='menu-item'>" + error + "</li>")
  })
}
