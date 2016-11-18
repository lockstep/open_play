describe SendConfirmationMailer do
  describe '#booking_confirmation' do
    before do
      @user = create(:user)
      @order = create(:order, user: @user)
      @lane = create(:lane, name: 'Classic Bowling')
      @booking = create(
        :booking,
        order: @order,
        reservable: @lane,
        start_time: '16:00',
        end_time: '17:00',
        booking_date: '2020-01-20',
        number_of_players: 2
      )
      @booking.set_total_price
      @booking.save
    end
    it 'shows booking information' do
      SendConfirmationMailer.booking_confirmation(@order.id).deliver_now
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq [@user.email]

      text_body = mail.text_part.body.to_s
      html_body = mail.html_part.body.to_s

      # Booking Number
      expect(text_body).to include @order.id.to_s
      expect(html_body).to include @order.id.to_s
      # Booking Date
      expect(text_body).to include 'Monday, January 20'
      expect(html_body).to include 'Monday, January 20'
      # Booking Place
      expect(text_body).to include @order.booking_place
      expect(html_body).to include @order.booking_place
      # Total Price
      expect(text_body).to include '$ 35.0'
      expect(html_body).to include '$ 35.0'

      # Booking details
      expect(text_body).to include @lane.name
      expect(html_body).to include @lane.name
      expect(text_body).to include '04:00 PM - 05:00 PM'
      expect(html_body).to include '04:00 PM - 05:00 PM'
    end
  end
end
