class SendConfirmationSmsJob < ApplicationJob
  queue_as :default

  def perform(params)
    order = Order.find(params[:order_id])
    client = Twilio::REST::Client.new
    client.messages.create(body: order.sms_message,
                           from: ENV['TWILIO_PHONE_NUMBER'],
                           to: order.client_phone_number)
  end
end
