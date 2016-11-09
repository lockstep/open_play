class SendConfirmationMailer < ApplicationMailer
  helper :date_time
  helper :order
  default from: 'no-reply@openplay.io'

  def booking_confirmation(order_id)
    @order = Order.find_by_id(order_id)
    @reserver = @order.reserver
    mail to: @reserver.email, subject: "OpenPlay - Booking Confirmation # #{order_id}"
  end
end
