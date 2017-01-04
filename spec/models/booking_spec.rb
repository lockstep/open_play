describe Booking do
  describe '#base_booking_price' do
    before do
      @activity = create(:activity)
      @reservable_1 = create(:room,
        activity: @activity,
        start_time: '09:00:00',
        end_time: '17:00:00',
        interval: 60,
        weekday_price: 10,
        weekend_price: 20,
        per_person_weekday_price: 15,
        per_person_weekend_price: 25
      )
      @reservable_2 = create(:room,
        activity: @activity,
        start_time: '09:00:00',
        end_time: '17:00:00',
        interval: 60,
        weekday_price: 10,
        weekend_price: 20,
        per_person_weekday_price: 17,
        per_person_weekend_price: 28
      )
      @order = create(:order, activity: @activity)
    end
    context 'rate override schedules exists' do
      before do
        create(:rate_override_schedule, activity: @activity,
          overridden_specific_day: true,
          overridden_on: '28 Nov 2016',
          overridden_all_day: true,
          overridden_all_reservables: true,
          price: 30,
          per_person_price: 35
        )
        create(:rate_override_schedule, activity: @activity,
          overridden_specific_day: true,
          overridden_on: '29 Nov 2016',
          overridden_all_day: false,
          overriding_begins_at: '01:00pm',
          overriding_ends_at: '02:00pm',
          overridden_all_reservables: false,
          overridden_reservables: [@reservable_2.id],
          price: 40,
          per_person_price: 45
        )
        create(:rate_override_schedule, activity: @activity,
          overridden_specific_day: false,
          overridden_days: ['Saturday'],
          overridden_all_day: true,
          overridden_all_reservables: false,
          overridden_reservables: [@reservable_2.id],
          price: 50,
          per_person_price: 55
        )
      end
      context 'match with rate override schedules' do
        it 'returns rate override schedule price' do
          booking = described_class.new(
            start_time: '09:00:00',
            end_time: '10:00:00',
            booking_date: '2016-11-28',
            order_id: @order.id,
            reservable_id: @reservable_1.id
          )
          expect(booking.base_booking_price).to eq 30
        end
        it 'returns rate override schedule price' do
          booking = described_class.new(
            start_time: '13:00:00',
            end_time: '14:00:00',
            booking_date: '2016-11-29',
            order_id: @order.id,
            reservable_id: @reservable_2.id
          )
          expect(booking.base_booking_price).to eq 40
        end
        it 'returns rate override schedule price' do
          booking = described_class.new(
            start_time: '09:00:00',
            end_time: '10:00:00',
            booking_date: '2016-12-03',
            order_id: @order.id,
            reservable_id: @reservable_2.id
          )
          expect(booking.base_booking_price).to eq 50
        end
      end
      context 'does not match with rate override schedules' do
        it 'returns reservable price' do
          booking = described_class.new(
            start_time: '13:00:00',
            end_time: '14:00:00',
            booking_date: '2016-11-29',
            order_id: @order.id,
            reservable_id: @reservable_1.id
          )
          expect(booking.base_booking_price).to eq 10
        end
        it 'returns reservable price' do
          booking = described_class.new(
            start_time: '13:00:00',
            end_time: '14:00:00',
            booking_date: '2016-11-29',
            order_id: @order.id,
            reservable_id: @reservable_1.id
          )
          expect(booking.base_booking_price).to eq 10
        end
        it 'returns reservable price' do
          booking = described_class.new(
            start_time: '09:00:00',
            end_time: '10:00:00',
            booking_date: '2016-12-03',
            order_id: @order.id,
            reservable_id: @reservable_1.id
          )
          expect(booking.base_booking_price).to eq 20
        end
      end
    end
    context 'rate override schedule does not exist' do
      it 'returns reservable price' do
        booking = described_class.new(
          start_time: '09:00:00',
          end_time: '10:00:00',
          booking_date: '2016-11-28',
          order_id: @order.id,
          reservable_id: @reservable_1.id
        )
        expect(booking.base_booking_price).to eq 10
      end
    end
  end

  describe '#per_person_price' do
    before do
      @activity = create(:activity)
      @reservable_1 = create(:room,
        activity: @activity,
        start_time: '09:00:00',
        end_time: '17:00:00',
        interval: 60,
        weekday_price: 10,
        weekend_price: 20,
        per_person_weekday_price: 15,
        per_person_weekend_price: 25
      )
      @reservable_2 = create(:room,
        activity: @activity,
        start_time: '09:00:00',
        end_time: '17:00:00',
        interval: 60,
        weekday_price: 10,
        weekend_price: 20,
        per_person_weekday_price: 17,
        per_person_weekend_price: 28
      )
      @order = create(:order, activity: @activity)
    end
    context 'rate override schedules exists' do
      before do
        create(:rate_override_schedule, activity: @activity,
          overridden_specific_day: true,
          overridden_on: '28 Nov 2016',
          overridden_all_day: true,
          overridden_all_reservables: true,
          price: 30,
          per_person_price: 35
        )
        create(:rate_override_schedule, activity: @activity,
          overridden_specific_day: true,
          overridden_on: '29 Nov 2016',
          overridden_all_day: false,
          overriding_begins_at: '01:00pm',
          overriding_ends_at: '02:00pm',
          overridden_all_reservables: false,
          overridden_reservables: [@reservable_2.id],
          price: 40,
          per_person_price: 45
        )
        create(:rate_override_schedule, activity: @activity,
          overridden_specific_day: false,
          overridden_days: ['Saturday'],
          overridden_all_day: true,
          overridden_all_reservables: false,
          overridden_reservables: [@reservable_2.id],
          price: 50,
          per_person_price: 55
        )
      end
      context 'match with rate override schedules' do
        it 'returns rate override schedule price' do
          booking = described_class.new(
            start_time: '09:00:00',
            end_time: '10:00:00',
            booking_date: '2016-11-28',
            order_id: @order.id,
            reservable_id: @reservable_1.id
          )
          expect(booking.per_person_price).to eq 35
        end
        it 'returns rate override schedule price' do
          booking = described_class.new(
            start_time: '13:00:00',
            end_time: '14:00:00',
            booking_date: '2016-11-29',
            order_id: @order.id,
            reservable_id: @reservable_2.id
          )
          expect(booking.per_person_price).to eq 45
        end
        it 'returns rate override schedule price' do
          booking = described_class.new(
            start_time: '09:00:00',
            end_time: '10:00:00',
            booking_date: '2016-12-03',
            order_id: @order.id,
            reservable_id: @reservable_2.id
          )
          expect(booking.per_person_price).to eq 55
        end
      end
      context 'does not match with rate override schedules' do
        it 'returns reservable price' do
          booking = described_class.new(
            start_time: '13:00:00',
            end_time: '14:00:00',
            booking_date: '2016-11-29',
            order_id: @order.id,
            reservable_id: @reservable_1.id
          )
          expect(booking.per_person_price).to eq 15
        end
        it 'returns reservable price' do
          booking = described_class.new(
            start_time: '15:00:00',
            end_time: '16:00:00',
            booking_date: '2016-11-29',
            order_id: @order.id,
            reservable_id: @reservable_2.id
          )
          expect(booking.per_person_price).to eq 17
        end
        it 'returns reservable price' do
          booking = described_class.new(
            start_time: '09:00:00',
            end_time: '10:00:00',
            booking_date: '2016-12-03',
            order_id: @order.id,
            reservable_id: @reservable_1.id
          )
          expect(booking.per_person_price).to eq 25
        end
      end
    end
    context 'rate override schedule does not exist' do
      it 'returns reservable price' do
        booking = described_class.new(
          start_time: '09:00:00',
          end_time: '10:00:00',
          booking_date: '2016-11-28',
          order_id: @order.id,
          reservable_id: @reservable_1.id
        )
        expect(booking.per_person_price).to eq 15
      end
    end
  end

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

  describe '#number_of_time_slots' do
    it 'returns correct number_of_time_slots' do
      @booking = create(:booking,
        start_time: '09:00:00',
        end_time: '12:00:00'
      )
      expect(@booking.number_of_time_slots).to eq 3
    end

    it 'returns correct number_of_time_slots' do
      @booking = create(:booking,
        start_time: '13:00:00',
        end_time: '15:00:00'
      )
      expect(@booking.number_of_time_slots).to eq 2
    end
  end

  describe '#calculate_booking_price' do
    it 'returns correct booking_price' do
      @booking = create(:booking,
        start_time: '09:00:00',
        end_time: '12:00:00',
        booking_date: '2017-01-03',
        number_of_players: 5
      )
      # 3 slots * (5 + (5 players * 15))
      expect(@booking.calculate_booking_price).to eq 240
    end
  end
end
