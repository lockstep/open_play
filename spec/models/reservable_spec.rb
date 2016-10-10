describe Reservable do

  describe 'reservables exist' do
    before do
      @lane = create(:lane)
      @room = create(:room)
    end
    context 'having reservable options provided' do
      before do
        @option_1 = ReservableOption.create(name: 'bumper', reservable_type: 'Lane')
        @option_2 = ReservableOption.create(name: 'handicap_accessible', reservable_type: 'Lane')
      end
      scenario 'links to the correct options' do
        expect(@lane.options.size).to eq 2
        expect(@room.options.size).to eq 0
      end
      context '#reservable_options_available' do
        context 'the lane has bumper' do
          before do
            @lane.options_availables.create(reservable_option: @option_1)
          end
          scenario 'saves the available options correctly' do
            expect(@lane.options_availables.size).to eq 1
            lane_option = @lane.options_availables.first
            expect(lane_option.reservable_option.name).to eq 'bumper'
          end
        end
      end
    end
  end

  describe '#build_time_slots' do
    context 'Bowling exists' do
      before do
        @bowling = create(:bowling, start_time: '09:00', end_time: '20:00')
        @lane = create(
          :lane,
          activity: @bowling,
          interval: 30,
          start_time: '09:00',
          end_time: '20:00'
        )
      end
      context 'the lane has no bookings yet' do
        scenario 'returns its available time slots correctly' do
          time_slots = @lane.build_time_slots('2016-10-10', '11:00am')
          expect(time_slots.size).to eq 5
          time_slot_1 = time_slots.first
          time_slot_2 = time_slots.second
          expect(time_slot_1 + @lane.interval.minutes).to eq time_slot_2
          expect(time_slots.third).to eq '11:00'
        end
      end
      context 'the lane has one booking' do
        before do
          @order = Order.create(user: create(:user))
          @booking = Booking.create(
            start_time: '10:00',
            end_time: '10:30',
            booking_date: '2016-10-10',
            number_of_players: 2,
            reservable: @lane,
            order: @order
          )
        end
        scenario 'returns its available time slots correctly' do
          time_slots = @lane.build_time_slots('2016-10-10', '11:00am')
          expect(time_slots.size).to eq 5
          expect(time_slots.first).to eq nil
          expect(time_slots.second).to eq '10:30'
          expect(time_slots.third).to eq '11:00'
        end
      end
    end
  end
end
