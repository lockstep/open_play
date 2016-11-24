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
      it 'links to the correct options' do
        expect(@lane.options.size).to eq 2
        expect(@room.options.size).to eq 0
      end
      context '#reservable_options_available' do
        context 'the lane has bumper' do
          before do
            @lane.options_available.create(reservable_option: @option_1)
          end
          it 'saves the available options correctly' do
            expect(@lane.options_available.size).to eq 1
            lane_option = @lane.options_available.first
            expect(lane_option.reservable_option.name).to eq 'bumper'
          end
        end
      end
    end
  end

  describe '#out_of_service' do
    before do
      @bowling = create(:bowling, start_time: '06:00:00', end_time: '18:00:00' )
      @lane_1 = create(:lane, start_time: '07:00', end_time: '17:00',
        activity: @bowling, interval: 60)
      @lane_2 = create(:lane, start_time: '07:00', end_time: '17:00',
        activity: @bowling, interval: 60)
    end

    context 'closed schedule is created' do
      context 'scheduling all day' do
        context 'on specific day' do
          context 'on some reservables' do
            before do
              create(:closed_schedule,
                closed_all_day: true,
                closed_specific_day: true,
                closed_on: '10 Nov 2016',
                closed_all_reservables: false,
                closed_reservables: [@lane_1.id],
                activity: @bowling)
            end
            context 'users search on closed day' do
              before do
                @begin_date_time = "10/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "10/Nov/2016 10:00:00".to_datetime
              end
              it 'returns correct results' do
                until @begin_date_time == @closing_date_time do
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
            context 'users search on other day' do
              before do
                @begin_date_time = "12/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "12/Nov/2016 10:00:00".to_datetime
              end
              it 'returns correct results' do
                until @begin_date_time == @closing_date_time do
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
          end
          context 'on all reservables' do
            before do
              create(:closed_schedule,
                closed_all_day: true,
                closed_specific_day: true,
                closed_on: '10 Nov 2016',
                closed_all_reservables: true,
                activity: @bowling
              )
            end
            context 'users search on closed day' do
              before do
                @begin_date_time = "10/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "10/Nov/2016 10:00:00".to_datetime
              end

              it 'returns correct results' do
                until @begin_date_time == @closing_date_time do
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be true
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
            context 'user search on other day' do
              before do
                @begin_date_time = "12/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "12/Nov/2016 10:00:00".to_datetime
              end
              it 'returns correct results' do
                until @begin_date_time == @closing_date_time do
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
          end
        end
        context 'in every monday and tuesday' do
          context 'on some reservables' do
            before do
              create(:closed_schedule,
                closed_all_day: true,
                closed_specific_day: false,
                closed_days: ['Monday', 'Tuesday'],
                closed_all_reservables: false,
                closed_reservables: [@lane_1.id],
                activity: @bowling
              )
            end
            context 'users search on monday' do
              before do
                @begin_date_time = "14/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "14/Nov/2016 10:00:00".to_datetime
              end
              it 'returns correct results' do
                until @begin_date_time == @closing_date_time do
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
            context 'users search on tuesday' do
              before do
                @begin_date_time = "15/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "15/Nov/2016 10:00:00".to_datetime
              end
              it 'returns correct results' do
                until @begin_date_time == @closing_date_time do
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
            context 'users search on other day' do
              before do
                @begin_date_time = "17/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "17/Nov/2016 10:00:00".to_datetime
              end
              it 'returns correct results' do
                until @begin_date_time == @closing_date_time do
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
          end
          context 'on all reservables' do
            before do
              create(:closed_schedule,
                closed_all_day: true,
                closed_specific_day: false,
                closed_days: ['Monday', 'Tuesday'],
                closed_all_reservables: true,
                activity: @bowling
              )
            end
            context 'users search on monday' do
              before do
                @begin_date_time = "14/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "14/Nov/2016 10:00:00".to_datetime
              end
              it 'returns correct results' do
                until @begin_date_time == @closing_date_time do
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be true
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
            context 'users search on other day' do
              before do
                @begin_date_time = "17/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "17/Nov/2016 10:00:00".to_datetime
              end
              it 'returns correct results' do
                until @begin_date_time == @closing_date_time do
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
          end
        end
      end
      context 'scheduling on specific time' do
        context 'on specific day' do
          context 'on some reservables' do
            before do
              create(:closed_schedule,
                closed_all_day: false,
                closing_begins_at: '08:00am',
                closing_ends_at: '11:00am',
                closed_specific_day: true,
                closed_on: '10 Nov 2016',
                closed_all_reservables: false,
                closed_reservables: [@lane_1.id],
                activity: @bowling
              )
            end
            context 'users search on closed day' do
              context 'users search on closed time' do
                before do
                  @begin_date_time = "10/Nov/2016 07:00:00".to_datetime
                  @closing_date_time = "10/Nov/2016 17:00:00".to_datetime
                end
                it 'returns correct results' do
                  start_closed_time = Time.parse('08:00:00')
                  end_closed_time = Time.parse('11:00:00')
                  until @begin_date_time == @closing_date_time do
                    checking_time = Time.parse(@begin_date_time.strftime("%I:%M%p"))
                    if checking_time.between?(start_closed_time, end_closed_time - 1.seconds) # Minus with one is a trick to tell rails to not count the end time
                      expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                    else
                      expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                    end
                    expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                    @begin_date_time = @begin_date_time + 1.hours
                  end
                end
              end
            end
          end
          context 'on all reservables' do
            before do
              create(:closed_schedule,
                closed_all_day: false,
                closing_begins_at: '08:00am',
                closing_ends_at: '11:00am',
                closed_specific_day: true,
                closed_on: '10 Nov 2016',
                closed_all_reservables: true,
                activity: @bowling
              )
            end
            context 'users search on closed day' do
              context 'users search on closed time' do
                before do
                  @begin_date_time = "10/Nov/2016 07:00:00".to_datetime
                  @closing_date_time = "10/Nov/2016 17:00:00".to_datetime
                end
                it 'returns correct results' do
                  start_closed_time = Time.parse('08:00:00')
                  end_closed_time = Time.parse('11:00:00')
                  until @begin_date_time == @closing_date_time do
                    checking_time = Time.parse(@begin_date_time.strftime("%I:%M%p"))
                    if checking_time.between?(start_closed_time, end_closed_time - 1.seconds)
                      expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                      expect(@lane_2.out_of_service?(@begin_date_time)).to be true
                    else
                      expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                      expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                    end
                    @begin_date_time = @begin_date_time + 1.hours
                  end
                end
              end
            end
          end
        end
        context 'in every monday and friday' do
          context 'on some reservables' do
            before do
              create(:closed_schedule,
                closed_all_day: false,
                closing_begins_at: '08:00am',
                closing_ends_at: '11:00am',
                closed_specific_day: false,
                closed_days: ['Monday', 'Friday'],
                closed_all_reservables: false,
                closed_reservables: [@lane_1.id],
                activity: @bowling
              )
            end
            context 'users search on monday' do
              before do
                @begin_date_time = "14/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "14/Nov/2016 17:00:00".to_datetime
              end
              it 'returns correct results' do
                start_closed_time = Time.parse('08:00:00')
                end_closed_time = Time.parse('11:00:00')
                until @begin_date_time == @closing_date_time do
                  checking_time = Time.parse(@begin_date_time.strftime("%I:%M%p"))
                  if checking_time.between?(start_closed_time, end_closed_time - 1.seconds)
                    expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                  else
                    expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                  end
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
            context 'users search on friday' do
              before do
                @begin_date_time = "18/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "18/Nov/2016 17:00:00".to_datetime
              end
              it 'returns correct results' do
                start_closed_time = Time.parse('08:00:00')
                end_closed_time = Time.parse('11:00:00')
                until @begin_date_time == @closing_date_time do
                  checking_time = Time.parse(@begin_date_time.strftime("%I:%M%p"))
                  if checking_time.between?(start_closed_time, end_closed_time - 1.seconds)
                    expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                  else
                    expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                  end
                  expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
          end
          context 'on all reservables' do
            before do
              create(:closed_schedule,
                closed_all_day: false,
                closing_begins_at: '08:00am',
                closing_ends_at: '11:00am',
                closed_specific_day: false,
                closed_days: ['Monday', 'Friday'],
                closed_all_reservables: true,
                activity: @bowling
              )
            end
            context 'users search on monday' do
              before do
                @begin_date_time = "14/Nov/2016 07:00:00".to_datetime
                @closing_date_time = "14/Nov/2016 17:00:00".to_datetime
              end
              it 'returns correct results' do
                start_closed_time = Time.parse('08:00:00')
                end_closed_time = Time.parse('11:00:00')
                until @begin_date_time == @closing_date_time do
                  checking_time = Time.parse(@begin_date_time.strftime("%I:%M%p"))
                  if checking_time.between?(start_closed_time, end_closed_time - 1.seconds)
                    expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                    expect(@lane_2.out_of_service?(@begin_date_time)).to be true
                  else
                    expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                    expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                  end
                  @begin_date_time = @begin_date_time + 1.hours
                end
              end
            end
          end
        end
      end
      context 'special cases' do
        context 'scheduling in half an hour unit' do
          before do
            create(:closed_schedule,
              closed_all_day: false,
              closing_begins_at: '08:30am',
              closing_ends_at: '10:30am',
              closed_specific_day: true,
              closed_on: '7 Nov 2016',
              closed_all_reservables: false,
              closed_reservables: [@lane_1.id],
              activity: @bowling
            )
          end
          context 'users search on closed time' do
            before do
              @begin_date_time = "07/Nov/2016 07:00:00".to_datetime
              @closing_date_time = "07/Nov/2016 17:00:00".to_datetime
            end
            it 'returns correct results' do
              start_closed_time = Time.parse('08:00:00')
              end_closed_time = Time.parse('11:00:00')
              until @begin_date_time == @closing_date_time do
                checking_time = Time.parse(@begin_date_time.strftime("%I:%M%p"))
                if checking_time.between?(start_closed_time, end_closed_time - 1.seconds)
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                else
                  expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                end
                expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                @begin_date_time = @begin_date_time + 1.hours
              end
            end
          end
        end
        context 'two closed schedules is created' do
          context 'on specific day' do
            context 'on some reservables' do
              before do
                create(:closed_schedule,
                  closed_all_day: false,
                  closing_begins_at: '08:00am',
                  closing_ends_at: '11:00am',
                  closed_specific_day: true,
                  closed_on: '10 Nov 2016',
                  closed_all_reservables: false,
                  closed_reservables: [@lane_1.id],
                  activity: @bowling
                )
                create(:closed_schedule,
                  closed_all_day: false,
                  closing_begins_at: '01:30pm',
                  closing_ends_at: '02:30pm',
                  closed_specific_day: true,
                  closed_on: '10 Nov 2016',
                  closed_all_reservables: false,
                  closed_reservables: [@lane_1.id],
                  activity: @bowling
                )
              end
              context 'users search on closed day' do
                context 'users search on closed time' do
                  before do
                    @begin_date_time = "10/Nov/2016 07:00:00".to_datetime
                    @closing_date_time = "10/Nov/2016 17:00:00".to_datetime
                  end
                  it 'returns correct results' do
                    start_closed_time_in_first_range = Time.parse('08:00:00')
                    end_closed_time_in_first_range = Time.parse('11:00:00')
                    start_closed_time_in_second_range = Time.parse('13:00:00')
                    end_closed_time_in_second_range = Time.parse('15:00:00')
                    until @begin_date_time == @closing_date_time do
                      checking_time = Time.parse(@begin_date_time.strftime("%I:%M%p"))
                      if checking_time.between?(
                          start_closed_time_in_first_range,
                          end_closed_time_in_first_range - 1.seconds
                        ) || checking_time.between?(
                          start_closed_time_in_second_range,
                          end_closed_time_in_second_range - 1.seconds
                        )
                        expect(@lane_1.out_of_service?(@begin_date_time)).to be true
                      else
                        expect(@lane_1.out_of_service?(@begin_date_time)).to be false
                      end
                      expect(@lane_2.out_of_service?(@begin_date_time)).to be false
                      @begin_date_time = @begin_date_time + 1.hours
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
