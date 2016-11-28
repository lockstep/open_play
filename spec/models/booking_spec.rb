describe Booking do
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

  describe '#base_booking_price' do
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
end
