describe TimeSlotsHelper do
  describe '#build_time_slots' do
    context 'Bowling exists' do
      before do
        @user = create(:user)
        @bowling = create(:bowling, start_time: '09:00', end_time: '20:00')
        @lane = create(
          :lane,
          activity: @bowling,
          interval: 60,
          start_time: '09:00',
          end_time: '20:00'
        )
      end
      context 'the lane has no bookings yet' do
        scenario 'returns every possible time slots' do
          time_slots = build_time_slots(@lane, '2016-10-10')
          expect(time_slots.size).to eq 11
          expect(time_slots.first[:time].strftime("%H:%M")).to eq '09:00'
          expect(time_slots.first[:booking_info][:available]).to eq true
          expect(time_slots.last[:time].strftime("%H:%M")).to eq '19:00'
          expect(time_slots.last[:booking_info][:available]).to eq true
        end
      end

      context 'the lane has one booking' do
        before do
          @order = create(:order, activity: @bowling, user: @user)
          @booking = create(
            :booking,
            start_time: '19:00',
            end_time: '20:00',
            booking_date: '2016-10-10',
            number_of_players: 2,
            reservable: @lane,
            order: @order
          )
        end
        scenario 'returns the time of each slot the same as no booking' do
          time_slots = build_time_slots(@lane, '2016-10-10')
          expect(time_slots.size).to eq 11
          expect(time_slots.first[:time].strftime("%H:%M")).to eq '09:00'
          expect(time_slots.last[:time].strftime("%H:%M")).to eq '19:00'
        end
        scenario 'returns the available of each slot correctly' do
          time_slots = build_time_slots(@lane, '2016-10-10')
          expect(time_slots.first[:booking_info][:available]).to eq true
          expect(time_slots.last[:booking_info][:available]).to eq false
        end
        scenario 'returns who booked the time slots' do
          time_slots = build_time_slots(@lane, '2016-10-10')
          expect(time_slots.first[:booking_info][:available]).to eq true
          expect(time_slots.first[:booking_info][:booked_by]).to be_nil
          expect(time_slots.last[:booking_info][:available]).to eq false
          expect(time_slots.last[:booking_info][:booked_by]).to eq @user.id
        end
        context 'multi-party bookings are allowed' do
          before do
            @bowling.update(allow_multi_party_bookings: true)
          end
          context 'has some spots left' do
            context 'any user wants to book' do
              scenario 'shows that the booked time slot is still available' do
                time_slots = build_time_slots(@lane, '2016-10-10')
                expect(time_slots.first[:booking_info][:available]).to eq true
                expect(time_slots.first[:booking_info][:booked_by]).to be_nil
                expect(time_slots.last[:booking_info][:available]).to eq true
                expect(time_slots.last[:booking_info][:booked_by]).to eq @user.id
              end
            end
          end
          context 'no spots left' do
            before do
              @booking = create(
                :booking,
                start_time: '19:00',
                end_time: '20:00',
                booking_date: '2016-10-10',
                number_of_players: 28,
                reservable: @lane,
                order: @order
              )
            end
            scenario 'shows that the time slot is unavailable' do
              time_slots = build_time_slots(@lane, '2016-10-10')
              expect(time_slots.first[:booking_info][:available]).to eq true
              expect(time_slots.last[:booking_info][:available]).to eq false
            end
          end
        end
      end

      context '24-hour reservable' do
        before do
          @bowling.update(start_time: '09:00', end_time: '09:00')
          @lane.update(start_time: '09:00', end_time: '09:00')
        end
        scenario 'shows the rest of time slots until midnight' do
          time_slots = build_time_slots(@lane, '2016-10-10')
          expect(time_slots.size).to eq 24
          expect(time_slots.first[:time].strftime("%H:%M")).to eq '00:00'
          expect(time_slots.last[:time].strftime("%H:%M")).to eq '23:00'
        end
      end

      context '#requested_time_slot_index' do
        context '#requested time' do
          context 'blank' do
            scenario 'returns 0' do
              slot_index = requested_time_slot_index(@lane, '2016-10-10', '')
              expect(slot_index).to eq 0
            end
          end
          context 'valid' do
            scenario 'returns the correct index' do
              slot_index = requested_time_slot_index(@lane, '2016-10-10', '10:00')
              expect(slot_index).to eq 1
            end
          end
          context 'out of service' do
            scenario 'still returns the index' do
              slot_index = requested_time_slot_index(@lane, '2016-10-10', '7:00')
              expect(slot_index).to eq -2
            end
          end
        end
      end

    end
  end
end
