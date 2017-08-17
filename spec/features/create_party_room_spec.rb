feature 'Create Party Room', :js do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
    @bowling = create(:bowling, business: @business)
  end
  include_context 'logged in user'

  context 'lane does not exist' do
    scenario 'business owner cannot create a party room' do
      visit root_path
      click_link 'Manage Business'
      expect(page).to_not have_link 'Add a Party room'
    end

    scenario 'business owner should not see number of party room' do
      visit root_path
      click_link 'Manage Business'
      expect(page).to_not have_text '0 PartyRooms'
    end
  end

  context 'lanes exist' do
    background do
      @lane = create(:lane, activity: @bowling)
      @lane_two = create(:lane, name: 'Lane 2', activity: @bowling)
    end

    scenario 'priority number field is diabled by default' do
      visit root_path
      click_link 'Manage Business'
      click_link 'Add a Party room'
      expect(page).to have_field(
        'reservable_sub_reservables_0_priority_number', disabled: true)
    end

    context 'params are valid' do
      context 'one sub-reservable' do
        scenario 'successfully creates a party room' do
          visit root_path
          click_link 'Manage Business'
          click_link 'Add a Party room'
          complete_room_form
          determine_sub_reservable_with_priority_number(
            index: 0,
            lane_name: @lane.name,
            priority_number: 5
          )
          click_on 'Submit'

          expect(page).to have_content 'PartyRoom was successfully added'
          expect(page).to have_content '2 Lanes 1 PartyRoom'
          expect_party_room_created
          expect_children_reservable_created
        end
 
        def expect_party_room_created
          expect(Reservable.count).to eq 3
          party_room = Reservable.last
          expect(party_room.name).to eq 'PartyRoom 1'
          expect(party_room.description).to eq 'So much fun here'
          expect(party_room.headcount).to eq 10
          expect(party_room.maximum_players_per_sub_reservable).to eq 5
          expect(party_room.sub_reservables.count).to eq 1
          expect(party_room.sub_reservables.first).to eq @lane
          expect(party_room.children.count).to eq 1
        end

        def expect_children_reservable_created
          party_room = Reservable.last
          reservable_sub_reservables = party_room.children.first
          expect(reservable_sub_reservables.parent_reservable).to eq party_room
          expect(reservable_sub_reservables.sub_reservable).to eq @lane
          expect(reservable_sub_reservables.priority_number).to eq 5
        end
      end

      context 'two sub-reservables' do
        scenario 'successfully creates a party room' do
          visit root_path
          click_link 'Manage Business'
          click_link 'Add a Party room'
          complete_room_form
          determine_sub_reservable_with_priority_number(
            index: 0, lane_name: @lane.name, priority_number: 5
          )
          determine_sub_reservable_with_priority_number(
            index: 1, lane_name: @lane_two.name, priority_number: 10
          )
          click_on 'Submit'

          expect(page).to have_content 'PartyRoom was successfully added'
          expect(page).to have_content '2 Lanes 1 PartyRoom'
          expect_party_room_created
          expect_children_reservable_created
        end

        def expect_party_room_created
          expect(Reservable.count).to eq 3
          party_room = Reservable.last
          expect(party_room.name).to eq 'PartyRoom 1'
          expect(party_room.description).to eq 'So much fun here'
          expect(party_room.headcount).to eq 10
          expect(party_room.maximum_players_per_sub_reservable).to eq 5
          expect(party_room.sub_reservables.count).to eq 2
          expect(party_room.sub_reservables.first).to eq @lane
          expect(party_room.sub_reservables.last).to eq @lane_two
          expect(party_room.children.count).to eq 2
        end

        def expect_children_reservable_created
          party_room = Reservable.last
          reservable_sub_reservables = party_room.children.first
          expect(reservable_sub_reservables.parent_reservable).to eq party_room
          expect(reservable_sub_reservables.sub_reservable).to eq @lane
          expect(reservable_sub_reservables.priority_number).to eq 5
          reservable_sub_reservables_two = party_room.children.last
          expect(reservable_sub_reservables_two.parent_reservable).to eq party_room
          expect(reservable_sub_reservables_two.sub_reservable).to eq @lane_two
          expect(reservable_sub_reservables_two.priority_number).to eq 10
        end
      end
    end

    context 'params are invalid' do
      context 'zero headcount' do
        scenario 'does not create reservable' do
          visit root_path
          click_link 'Manage Business'
          click_link 'Add a Party room'
          complete_room_form(headcount: 0)
          determine_sub_reservable_with_priority_number(
            index: 0,
            lane_name: @lane.name,
            priority_number: 5
          )
          click_on 'Submit'
          expect(page).to have_content 'must be greater than 0'
        end
      end

      context 'zero maximum players per sub reservable' do
        scenario 'does not create reservable' do
          visit root_path
          click_link 'Manage Business'
          click_link 'Add a Party room'
          complete_room_form(players_per_sub_reservable: 0)
          determine_sub_reservable_with_priority_number(
            index: 0,
            lane_name: @lane.name,
            priority_number: 5
          )
          click_on 'Submit'
          expect(page).to have_content 'must be greater than 0'
        end
      end

      context 'business owner does not determine sub reservables' do
        scenario 'does not create reservable' do
          visit root_path
          click_link 'Manage Business'
          click_link 'Add a Party room'
          complete_room_form(uncheck_sub_reservable: true)
          click_on 'Submit'
          expect(page).to have_content 'must be choosen at least one'
        end
      end
    end

    context 'party room exists' do
      background { create(:party_room, activity: @bowling) }

      scenario 'user should not see party room as sub reservable' do
        visit root_path
        click_link 'Manage Business'
        click_link 'Add a Party room'
        expect(page).to_not have_content 'FunRoom'
      end
    end
  end

  def complete_room_form(overrides = {})
    fill_in :reservable_name, with: overrides[:name] || 'PartyRoom 1'
    fill_in :reservable_description, with: overrides[:description] || 'So much fun here'
    fill_in :reservable_headcount, with: overrides[:headcount] || 10
    fill_in :reservable_maximum_players_per_sub_reservable,
            with: overrides[:players_per_sub_reservable] || 5
    fill_in :reservable_interval, with: overrides[:interval] || 60
    fill_in :reservable_start_time, with: overrides[:start_time] || '2000-01-01 10:00:00 UTC'
    fill_in :reservable_end_time, with: overrides[:end_time] || '2000-01-01 12:00:00 UTC'
    fill_in :reservable_maximum_players, with: overrides[:maximum_players] || 30
    fill_in :reservable_weekday_price, with: overrides[:weekday_price] || 10
    fill_in :reservable_weekend_price, with: overrides[:weekend_price] || 20
    fill_in :reservable_per_person_weekday_price, with: overrides[:per_person_weekday_price] || 5
    fill_in :reservable_per_person_weekend_price, with: overrides[:per_person_weekend_price] || 10
  end

  def determine_sub_reservable_with_priority_number(params = {})
    check params[:lane_name]
    fill_in "reservable_sub_reservables_#{params[:index]}_priority_number",
            with: params[:priority_number] || 5
  end
end
