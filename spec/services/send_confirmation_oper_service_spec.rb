describe SendConfirmationOrderService do
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  context 'order is made by business owner' do
    before { @order = double('Order', id: 1, made_by_business_owner?: true) }

    it 'does not send an email confirmation' do
      action_mailer = double('ActionMailer', deliver_later: true)
      expect(SendConfirmationMailer).to_not receive(:booking_confirmation)
      SendConfirmationOrderService.call(order: @order, confirmation_channel: 'email')
    end

    it 'does not send sms confirmation' do
      expect do
        SendConfirmationOrderService.call(order: @order, confirmation_channel: 'sms')
      end.to_not have_enqueued_job(SendConfirmationSmsJob)
    end
  end

  context 'order is not made by business owner' do
    before { @order = double('Order', id: 1, made_by_business_owner?: false) }

    it 'sends an email confirmation' do
      action_mailer = double('ActionMailer', deliver_later: true)
      expect(SendConfirmationMailer).to receive(:booking_confirmation)
        .with(@order.id).and_return(action_mailer)
      SendConfirmationOrderService.call(order: @order, confirmation_channel: 'email')
    end

    it 'sends sms confirmation' do
      expect do
        SendConfirmationOrderService.call(order: @order, confirmation_channel: 'sms')
      end.to have_enqueued_job(SendConfirmationSmsJob).with(order_id: @order.id)
    end
  end
end
