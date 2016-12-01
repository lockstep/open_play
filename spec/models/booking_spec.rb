describe Booking do
  describe '#revenues_by_date_in_60_days' do
    before do
      @bowling = create(:bowling)
      @lane_1 = create(:lane, activity: @bowling,
        weekday_price: 5, per_person_weekday_price: 10)
      @lane_2 = create(:lane, activity: @bowling,
        weekday_price: 10, per_person_weekday_price: 15)
    end
    context 'booking exists' do
      before do
        @order_1 = create(:order, activity: @bowling)
        @booking = create(:booking, order: @order_1, reservable: @lane_1,
          start_time: '11:00', end_time: '12:00', booking_date: '2016-10-12',
          number_of_players: 1)
        @booking_2 = create(:booking, order: @order_1, reservable: @lane_2,
          start_time: '14:00', end_time: '15:00', booking_date: '2016-10-12',
          number_of_players: 1)
        @order_2 = create(:order, activity: @bowling)
        @booking_3 = create(:booking, order: @order_2, reservable: @lane_1,
          start_time: '11:00', end_time: '12:00', booking_date: '2016-10-13',
          number_of_players: 1)

        @order_1.set_price_of_bookings
        @order_1.save
        @order_2.set_price_of_bookings
        @order_2.save
      end
      scenario 'returns the results correctly' do
        results = Booking.revenues_by_date_in_60_days
        expect(results.count).to eq 2
        expect(results.keys[0]).to eq @booking.booking_date
        expect(results.values[0])
          .to eq @booking.reload.booking_price + @booking_2.reload.booking_price
        expect(results.keys[1]).to eq @booking_3.booking_date
        expect(results.values[1]).to eq @booking_3.reload.booking_price
      end

      context 'some of bookings have been canceled' do
        before do
          @booking.update(canceled: true)
          @booking_3.update(canceled: true)
        end
        scenario 'excludes canceled bookings' do
          results = Booking.revenues_by_date_in_60_days
          expect(results.count).to eq 1
          expect(results.keys[0]).to eq @booking.booking_date
          expect(results.values[0])
            .to eq @booking_2.reload.booking_price
        end
      end
    end

    context 'no bookings exist' do
      scenario 'returns empty array' do
        results = Booking.revenues_by_date_in_60_days
        expect(results.count).to eq 0
      end
    end
  end
end

