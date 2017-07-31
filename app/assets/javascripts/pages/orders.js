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

  $('.order-players').on('keyup', function(e) {
    var subTotalPrice = calculateSubTotalPrice(e);
    $('.subtotal-price').text('$ ' + subTotalPrice);
    var totalPrice = calculateTotalPrice(subTotalPrice);
    $('.total-price').text('$ ' + totalPrice);
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

function prepareCompleteOrder() {
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
      renderOrderErrors(xhr.responseJSON.meta.errors)
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

function calculateSubTotalPrice(e) {
  var subTotalPrice = 0.0;
  var rows = $(e.target).closest('tbody').find('tr');  
  $.each(rows, function(index, value) {
    var $tr = $(value);
    var numberOfPlayers = parseInt($tr.find('.order-players').val());
    if ($.isNumeric(numberOfPlayers) && numberOfPlayers != 0) {
      var baseBookingPriceText = $tr.find('.base-booking-price').text();
      var baseBookingPrice = getFloatValueFromPriceSring(baseBookingPriceText);
      var perPersonPriceText = $tr.find('.per-person-price').text();
      var perPersonPrice = getFloatValueFromPriceSring(perPersonPriceText);
      subTotalPrice += (baseBookingPrice + (numberOfPlayers * perPersonPrice));
    }
  });
  return subTotalPrice;
}

function calculateTotalPrice(subTotalPrice) {
  var openPlayFeeText = $('.openplay-fee').text();
  var openPlayFee = getFloatValueFromPriceSring(openPlayFeeText);
  if (subTotalPrice != 0) {
    return openPlayFee + subTotalPrice;
  } else {
    return 0;
  }
}

function getFloatValueFromPriceSring(str) {
  return parseFloat(str.trim().replace('$ ', ''));
}
