class SendConfirmationOrderService
  def self.call(params)
    order = params[:order]
    confirmation_channel = params[:confirmation_channel]

    return if order.made_by_business_owner?
    if confirmation_channel == 'email'
      SendConfirmationMailer.booking_confirmation(order.id).deliver_later
    else
      SendConfirmationSmsJob.perform_later(order_id: order.id)
    end
  end
end
