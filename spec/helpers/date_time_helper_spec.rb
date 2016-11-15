describe DateTimeHelper do
  describe '#round_up_time' do
    context '60-minute interval' do
      context 'time is on hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_up_time(Time.parse('09:00'), 60.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:00'
        end
      end
      context 'time is on half hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_up_time(Time.parse('09:30'), 60.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '10:00'
        end
      end
    end
    context '30-minute interval' do
      context 'time is on hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_up_time(Time.parse('09:00'), 30.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:00'
        end
      end
      context 'time is on half hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_up_time(Time.parse('09:30'), 30.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:30'
        end
      end
    end
    context '20-minute interval' do
      context 'time is on hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_up_time(Time.parse('09:00'), 20.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:00'
        end
      end
      context 'time is on half hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_up_time(Time.parse('09:30'), 20.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:40'
        end
      end
    end
  end

  describe '#round_down_time' do
    context '60-minute interval' do
      context 'time is on hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_down_time(Time.parse('09:00'), 60.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:00'
        end
      end
      context 'time is on half hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_down_time(Time.parse('09:30'), 60.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:00'
        end
      end
    end
    context '30-minute interval' do
      context 'time is on hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_down_time(Time.parse('09:00'), 30.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:00'
        end
      end
      context 'time is on half hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_down_time(Time.parse('09:30'), 30.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:30'
        end
      end
    end
    context '20-minute interval' do
      context 'time is on hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_down_time(Time.parse('09:00'), 20.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:00'
        end
      end
      context 'time is on half hour' do
        scenario 'returns the correct rounded time' do
          rounded_time = round_down_time(Time.parse('09:30'), 20.minutes)
          expect(rounded_time.strftime("%H:%M")).to eq '09:20'
        end
      end
    end
  end
end
