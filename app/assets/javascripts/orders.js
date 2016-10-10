$(function() {

  $('#complete-reservation').click(OPEN_PLAY.checkoutInitiator);

  window.addEventListener('popstate', function() {
    OPEN_PLAY.checkoutHandler.close();
  });

});

OPEN_PLAY.checkoutInitiator = function(e) {
  e.preventDefault();
  OPEN_PLAY.checkoutHandler.open({
    name: 'Open Play',
    description: '2 widgets',
    amount: 2000
  });
}

OPEN_PLAY.successfulChargeCallback = function(token) {
  $('#new-order-form').submit();
}

OPEN_PLAY.checkoutHandler = StripeCheckout.configure({
  key: OPEN_PLAY.stripeKey,
  image: OPEN_PLAY.iconImageUrl,
  locale: 'auto',
  token: OPEN_PLAY.successfulChargeCallback
});
