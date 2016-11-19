describe Order do
  describe '#total_price' do
    context 'books on weekday and on weekend date' do
      it 'sum bookings price correctly' do
        @order = create(:order)
        # weekday booking ($ 75)
        create(:booking, order: @order, booking_date: '2016-10-19', number_of_players: 5)
        # weekend booking ($ 100)
        create(:booking, order: @order, booking_date: '2016-10-22', number_of_players: 5)
        @order.set_price_of_bookings
        @order.save

        total_price = @order.reload.total_price
        expect(total_price).to eq 190.0
      end
    end
  end
end
