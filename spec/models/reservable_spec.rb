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
end
