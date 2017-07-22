module StripeHelpers
  def stub_stripe_checkout_handler
    page.execute_script(<<-JS)
      OPEN_PLAY.checkoutHandler = {
        open: function() {
          OPEN_PLAY.successfulChargeCallback({
            id: 'testId'
          });
        },
        close: function() {
          // NOOP
        }
      };
    JS
  end
end
