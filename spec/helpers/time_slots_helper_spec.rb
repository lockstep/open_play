describe TimeSlotsHelper do
  describe '#build_time_slots' do
    context 'Bowling exists' do
      before do
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
        scenario 'returns the time of each slot correctly' do
          time_slots = build_time_slots(@lane, '2016-10-10', '5:00pm')
          expect(time_slots.size).to eq 3
          expect(time_slots.first[:time].strftime("%H:%M")).to eq '17:00'
          expect(time_slots.second[:time].strftime("%H:%M")).to eq '18:00'
          expect(time_slots.last[:time].strftime("%H:%M")).to eq '19:00'
        end
        scenario 'returns the available of each slot correctly' do
          time_slots = build_time_slots(@lane, '2016-10-10', '5:00pm')
          expect(time_slots.first[:available]).to eq true
          expect(time_slots.second[:available]).to eq true
          expect(time_slots.last[:available]).to eq true
        end
        context 'passes no time' do
          scenario 'returns every possible time slots' do
            time_slots = build_time_slots(@lane, '2016-10-10', '')
            expect(time_slots.size).to eq 11
            expect(time_slots.first[:time].strftime("%H:%M")).to eq '09:00'
            expect(time_slots.last[:time].strftime("%H:%M")).to eq '19:00'
          end
        end
      end
      context 'the lane has one booking' do
        before do
          @order = create(:order, activity: @bowling)
          @booking = create(
            :booking,
            start_time: '17:00',
            end_time: '18:00',
            booking_date: '2016-10-10',
            number_of_players: 2,
            reservable: @lane,
            order: @order
          )
        end
        scenario 'returns the time of each slot the same as no booking' do
          time_slots = build_time_slots(@lane, '2016-10-10', '17:00')
          expect(time_slots.size).to eq 3
          expect(time_slots.first[:time].strftime("%H:%M")).to eq '17:00'
          expect(time_slots.second[:time].strftime("%H:%M")).to eq '18:00'
          expect(time_slots.third[:time].strftime("%H:%M")).to eq '19:00'
        end
        scenario 'returns the available of each slot correctly' do
          time_slots = build_time_slots(@lane, '2016-10-10', '17:00')
          expect(time_slots.first[:available]).to eq false
          expect(time_slots.second[:available]).to eq true
          expect(time_slots.last[:available]).to eq true
        end
        context 'multi-party bookings are allowed' do
          before do
            @bowling.update(allow_multi_party_bookings: true)
          end
          context 'has some spots left' do
            scenario 'shows that the time slot is still available' do
              time_slots = build_time_slots(@lane, '2016-10-10', '17:00')
              expect(time_slots.first[:available]).to eq true
              expect(time_slots.second[:available]).to eq true
              expect(time_slots.last[:available]).to eq true
            end
          end
          context 'no spots left' do
            before do
              @booking = create(
                :booking,
                start_time: '17:00',
                end_time: '18:00',
                booking_date: '2016-10-10',
                number_of_players: 28,
                reservable: @lane,
                order: @order
              )
            end
            scenario 'shows that the time slot is unavailable' do
              time_slots = build_time_slots(@lane, '2016-10-10', '17:00')
              expect(time_slots.first[:available]).to eq false
              expect(time_slots.second[:available]).to eq true
              expect(time_slots.last[:available]).to eq true
            end
          end
        end
      end
    end
  end
end
