feature 'edit reservable' do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  context 'activity exist' do
    before { @activity = create(:bowling, business: @business) }

    context 'lane exists' do
      before { @reservable = create(:lane, activity: @activity) }

      context 'business owner is editting name' do
        context 'with valid name' do
          scenario 'successfully edited reservable' do
            navigate_to_edit_lane
            expect(page).to have_content 'Edit a Lane'
            fill_in :reservable_name, with: 'Amazing Lane 1'
            click_on 'Submit'
            expect(page).to have_content 'Successfully updated reservable'
            expect(page).to have_content 'Amazing Lane 1'
          end
        end

        context 'with blank' do
          scenario 'unsuccessfully edited reservable' do
            navigate_to_edit_lane
            expect(page).to have_content 'Edit a Lane'
            fill_in :reservable_name, with: ''
            click_on 'Submit'
            expect(page).to have_content "can't be blank"
          end
        end
      end
 
      context 'business owner is editting interval' do
        context 'with valid number' do
          scenario 'successfully edited reservable' do
            navigate_to_edit_lane
            expect(page).to have_content 'Edit a Lane'
            fill_in :reservable_interval, with: 25
            click_on 'Submit'
            expect(page).to have_content 'Successfully updated reservable'
            expect(page).to have_content 25
          end
        end

        context 'with blank' do
          scenario 'unsuccessfully edited reservable' do
            navigate_to_edit_lane
            expect(page).to have_content 'Edit a Lane'
            fill_in :reservable_interval, with: ''
            click_on 'Submit'
            expect(page).to have_content 'is not a number'
          end
        end
      end

      context 'business owner is editting per_person_weekday_price' do
        context 'with valid number' do
          scenario 'successfully edited reservable' do
            navigate_to_edit_lane
            fill_in :reservable_per_person_weekday_price, with: '15.8'
            click_on 'Submit'

            expect(page).to have_content '$15.80'
          end
        end

        context 'with text' do
          scenario 'unsuccessfully edited reservable' do
            navigate_to_edit_lane
            fill_in :reservable_per_person_weekday_price, with: 'abc'
            click_on 'Submit'

            expect(page).to have_content 'is not a number'
          end
        end
      end

      context 'business owner is editting per_person_weekend_price' do
        context 'with valid number' do
          scenario 'successfully edited reservable' do
            navigate_to_edit_lane
            fill_in :reservable_per_person_weekend_price, with: '20'
            click_on 'Submit'

            expect(page).to have_content '$20'
          end
        end

        context 'with text' do
          scenario 'unsuccessfully edited reservable' do
            navigate_to_edit_lane
            fill_in :reservable_per_person_weekend_price, with: 'abc'
            click_on 'Submit'

            expect(page).to have_content 'is not a number'
          end
        end
      end

      scenario 'business owner can edit description' do
        navigate_to_edit_lane
        fill_in 'reservable_description', with: 'hello world'
        click_on 'Submit'
        expect(page).to have_content 'Successfully updated reservable'
        expect(@reservable.reload.description).to eq 'hello world'
      end

      scenario 'business owner cannot see maximum_players_per_sub_reservable' do
        navigate_to_edit_lane
        expect(page).to_not have_field 'reservable_maximum_players_per_sub_reservable'
      end

      scenario 'business owner cannot edit sub_reservables' do
        navigate_to_edit_lane
        expect(page).to_not have_content 'Sub reservables'
      end

      def navigate_to_edit_lane
        visit root_path
        click_link 'Manage Business'
        click_link 'Edit'
        click_link 'Edit'
      end
    end

    context 'party room exists' do
      before { @reservable = create(:party_room, activity: @activity) }

      scenario 'business owner can edit description' do
        navigate_to_edit_party_room
        fill_in 'reservable_description', with: 'hello world'
        click_on 'Submit'
        expect(page).to have_content 'Successfully updated reservable'
        expect(@reservable.reload.description).to eq 'hello world'
      end

      scenario 'business owner can edit maximum_players_per_sub_reservable' do
        navigate_to_edit_party_room
        fill_in 'reservable_maximum_players_per_sub_reservable', with: 5
        click_on 'Submit'
        expect(page).to have_content 'Successfully updated reservable'
        expect(@reservable.reload.maximum_players_per_sub_reservable).to eq 5
      end

      scenario 'business owner cannot edit sub_reservables' do
        navigate_to_edit_party_room
        expect(page).to_not have_content 'Sub reservables'
      end

      def navigate_to_edit_party_room
        visit root_path
        click_link 'Manage Business'
        click_link 'Edit'
        within ".reservable_#{@reservable.id}" do
          click_link 'Edit'
        end
      end
    end
  end
end
