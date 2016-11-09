class SendConfirmationMailer < ApplicationMailer
  helper :date_time
  helper :order
  default from: 'info@openplay.com'

  def booking_confirmation(order)
    @order = order
    @user = @order.user || @order.guest
    mail to: @user.email, subject: "OpenPlay - Booking Confirmation # #{order.id}"
  end
end
