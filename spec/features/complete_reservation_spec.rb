feature 'Complete Reservation', js: true do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
    @bowling = create(:bowling, business: @business)
  end
  include_context 'logged in user'

  describe 'booking a lane' do
    background do
      @lane = create(:lane, activity: @bowling)
      visit root_path
      fill_in 'datepicker', with: '4/10/2016'
      click_on 'Search'
    end

    context 'books one time slot' do
      background do
        click_on '9:00 - 10:00'
        click_on 'Book'
      end

      scenario 'displays the booking info correctly' do
        expect(page).to have_content 'Tuesday, October 4'
        expect(page).to have_content @bowling.name
        expect(page).to have_content '9:00 AM - 10:00 AM'
        expect(find_field('order_bookings_0_players').value).to eq '1'
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            click_on 'Complete Reservation'
            expect(page).to have_content 'Thank you for your purchase'
          end
        end

        context 'params are invalid' do
          context 'num of players is missing' do
            scenario 'books unsuccessfully' do
              fill_in 'order_bookings_0_players', with: ''
              click_on 'Complete Reservation'
              expect(page).to have_content "can't be blank"
            end
          end
          context 'num of players is not an integer' do
            context 'num of players is string' do
              scenario 'books unsuccessfully' do
                fill_in 'order_bookings_0_players', with: 'hello'
                click_on 'Complete Reservation'
                expect(page).to have_content "is not a number"
              end
            end
            context 'num of players is floating point' do
              scenario 'books unsuccessfully' do
                fill_in 'order_bookings_0_players', with: '1.5'
                click_on 'Complete Reservation'
                expect(page).to have_content "must be an integer"
              end
            end
          end
          context 'num of players is less than zero' do
            scenario 'books unsuccessfully' do
              fill_in 'order_bookings_0_players', with: '-1'
              click_on 'Complete Reservation'
              expect(page).to have_content "must be greater than 0"
            end
          end
        end
      end
    end

    context 'books multiple time slots' do
      background do
        click_on '9:00 - 10:00'
        click_on '10:00 - 11:00'
        click_on 'Book'
      end

      scenario 'displays the booking info correctly' do
        expect(page).to have_content 'Tuesday, October 4'
        expect(page).to have_content @bowling.name
        expect(page).to have_content '9:00 AM - 10:00 AM'
        expect(page).to have_content '10:00 AM - 11:00 AM'
        expect(find_field('order_bookings_0_players').value).to eq '1'
        expect(find_field('order_bookings_1_players').value).to eq '1'
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            click_on 'Complete Reservation'
            expect(page).to have_content 'Thank you for your purchase'
          end
        end
      end
    end

    context 'does not book any time slots' do
      scenario 'books unsuccessfully' do
        click_on 'Book'
        expect(page).to have_content "Couldn't booking, please select any time slots"
      end
    end
  end
end
