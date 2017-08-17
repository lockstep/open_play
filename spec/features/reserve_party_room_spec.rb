feature 'reserve party room', :js do
  background do
    @business = create(:business)
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'booking lanes' do
    before do
      @bowling = create(:bowling, business: @business)
      @party_room = create(:party_room, activity: @bowling)
    end

    scenario 'user sees party room description' do
      user_searchs_for_bowling
      expect(page).to have_content 'Having a good time with us'
    end

    context 'max players is greater than sum number of players per sub reservable' do
      before { @party_room.update(maximum_players: 50) }

      context 'searching activities page' do
        scenario 'user sees sum of number of players per sub reservable as a maximum capacity' do
          user_searchs_for_bowling
          expect(page).to have_content 'Max 40 people per reservation'
        end
      end

      context 'new order page' do
        scenario 'user sees sum of number of players per sub reservable as a maximum capacity' do
          user_searchs_for_bowling
          user_selects_time_slots
          expect(page).to have_content '(0/40)'
        end
      end
    end

    context 'max players is less than sum number of players per sub reservable' do
      context 'searching activities page' do
        scenario 'user sees max number of players as maximum capacity' do
          user_searchs_for_bowling
          expect(page).to have_content 'Max 30 people per reservation'
        end
      end

      context 'new order page' do
        scenario 'user sees max number of players as maximum capacity' do
          user_searchs_for_bowling
          user_selects_time_slots
          expect(page).to have_content '(0/30)'
        end
      end
    end

    context 'booking at 11 am exists' do
      before do
        create(:booking,
               start_time: '11:00:00',
               end_time: '12:00:00',
               booking_date: '20 Jan 2020',
               reservable: @party_room.sub_reservables.first
        )
      end

      context 'bowling allows multi party bookings' do
        before { @bowling.update(allow_multi_party_bookings: true) }
        scenario 'user cannot reserve party room' do
          user_searchs_for_bowling
          expect_lane_1_availble_and_party_room_unavailable_at_11_am
        end
      end

      context 'bowling does not allow multi party bookings' do
        scenario 'user cannot reserve party room' do
          user_searchs_for_bowling
          expect_lane_1_and_party_room_booked_at_11_am
        end
      end
    end

    scenario 'reserves party room successfully' do
      expect(StripeCharger).to receive(:charge).with(
        an_instance_of(Money), String
      ).and_return(1365)
      expect(SendConfirmationOrderService).to receive(:call).with(
        hash_including(order: an_instance_of(Order),
                       confirmation_channel: 'email'
        )
      )

      user_searchs_for_bowling
      user_selects_time_slots
      user_completes_reservation
      expect_correct_order_price
      expect_lanes_being_allocated_by_priority
    end
  end

  def user_searchs_for_bowling
    visit root_path
    search_activities(activity_type: 'Bowling')
  end

  def user_selects_time_slots
    within "#reservable_#{@party_room.id}" do
      click_on '11:00'
      click_on '12:00'
      click_on '13:00'
    end
    click_on 'Book'
  end

  def user_completes_reservation
    stub_stripe_checkout_handler
    fill_in 'order_bookings_0_number_of_players', with: 30
    click_on 'Complete Reservation'
  end

  def expect_lane_1_and_party_room_booked_at_11_am
    within("#reservable_#{@party_room.sub_reservables.first.id}") do
      expect(page).to have_button('11:00', disabled: true)
    end
    within("#reservable_#{@party_room.id}") do
      expect(page).to have_button('11:00', disabled: true)
    end
  end

  def expect_lane_1_availble_and_party_room_unavailable_at_11_am
    within("#reservable_#{@party_room.sub_reservables.first.id}") do
      expect(page).to have_button('11:00', disabled: false)
    end
    within("#reservable_#{@party_room.id}") do
      expect(page).to have_button('11:00', disabled: true)
    end
  end

  def expect_correct_order_price
    expect(page).to have_content 'Reservation Info'
    expect(page).to have_content 'Tom Cruise'
    expect(page).to have_content '11:00 AM - 02:00 PM'
    expect(page).to have_content '$1,366'
  end

  def expect_lanes_being_allocated_by_priority
    expect_reservation_info_being_displayed
    expect_parent_booking_being_created
    expect_child_booking1_being_created
    expect_child_booking2_being_created
  end

  def expect_reservation_info_being_displayed
    expect(page).to have_content 'Reservation Info'
    expect(page).to have_content 'Monday, January 20'
    expect(page).to have_content 'Country Club Lanes'
    expect(page).to have_content 'Tom Cruise'
    expect_only_children_bookings_being_displayed
  end

  def expect_only_children_bookings_being_displayed
    expect(all('tbody tr').count).to eq 2
    expect(page).to_not have_content 'FunRoom'
    expect(page).to have_content 'lane 1'
    expect(page).to have_content 'lane 2'
  end

  def expect_parent_booking_being_created
    expect(Booking.count).to eq 3
    parent_booking = Booking.first
    expect(parent_booking.parent).to eq nil
    expect(parent_booking.children.count).to eq 2
    expect(parent_booking.start_time.to_s).to eq '2000-01-01 11:00:00 UTC'
    expect(parent_booking.end_time.to_s).to eq '2000-01-01 14:00:00 UTC'
    expect(parent_booking.booking_date.to_s).to eq '2020-01-20'
    expect(parent_booking.number_of_players).to eq 30
    expect(parent_booking.reservable).to eq @party_room
    expect(parent_booking.booking_price_cents).to eq 136_500
  end

  def expect_child_booking1_being_created
    child_booking1 = Booking.second
    expect(child_booking1.parent).to eq Booking.first
    expect(child_booking1.children.count).to eq 0
    expect(child_booking1.start_time.to_s).to eq '2000-01-01 11:00:00 UTC'
    expect(child_booking1.end_time.to_s).to eq '2000-01-01 14:00:00 UTC'
    expect(child_booking1.booking_date.to_s).to eq '2020-01-20'
    expect(child_booking1.number_of_players).to eq 20
    expect(child_booking1.reservable).to eq @party_room.sub_reservables.first
    expect(child_booking1.booking_price_cents).to eq 0
  end

  def expect_child_booking2_being_created
    child_booking2 = Booking.last
    expect(child_booking2.parent).to eq Booking.first
    expect(child_booking2.children.count).to eq 0
    expect(child_booking2.start_time.to_s).to eq '2000-01-01 11:00:00 UTC'
    expect(child_booking2.end_time.to_s).to eq '2000-01-01 14:00:00 UTC'
    expect(child_booking2.booking_date.to_s).to eq '2020-01-20'
    expect(child_booking2.number_of_players).to eq 10
    expect(child_booking2.reservable).to eq @party_room.sub_reservables.last
    expect(child_booking2.booking_price_cents).to eq 0
  end
end
