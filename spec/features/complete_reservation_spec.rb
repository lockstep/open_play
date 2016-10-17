feature 'Complete Reservation', :js do
  include ReservationHelpers

  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  describe 'booking a lane' do
    background do
      @bowling = create(:bowling, business: @business)
      @lane = create(:lane, activity: @bowling)
    end

    context 'books one time slot' do
      scenario 'displays the booking info correctly' do
        visit root_path
        search_activities
        click_on '09:00'
        click_on 'Book'

        expect(page).to have_content 'Monday, January 20'
        expect(page).to have_content @bowling.name
        expect(page).to have_content '9:00 AM - 10:00 AM'
        expect(page).to have_content '0/30'
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
      end
      context 'the lane has options for users to choose' do
        background do
          @option_1 = ReservableOption.create(name: 'bumper', reservable_type: 'Lane')
          @option_2 = ReservableOption.create(name: 'handicap_accessible', reservable_type: 'Lane')
          @lane.update(
            options_available_attributes: [
              { reservable_option: @option_1 },
              { reservable_option: @option_2 }
            ]
          )
        end
        scenario 'displays the available options correctly' do
          visit root_path
          search_activities
          click_on '09:00'
          click_on 'Book'
          expect(page).to have_content 'Bumper'
          expect(page).to have_content 'Handicap accessible'
        end
        scenario 'books with available options successfully' do
          visit root_path
          search_activities
          click_on '09:00'
          click_on 'Book'
          stub_stripe_checkout_handler
          check 'Bumper'
          check 'Handicap accessible'
          click_on 'Complete Reservation'
          expect(page).to have_content 'Thank you for your purchase'
        end
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            visit root_path
            search_activities
            click_on '09:00'
            click_on 'Book'
            stub_stripe_checkout_handler
            click_on 'Complete Reservation'
            expect(page).to have_content 'Thank you for your purchase'
          end
        end

        xcontext 'params are invalid' do
          # TODO: This will have to be validated on the front end now
          # because stripe will need these numbers.
          context 'number of players is missing' do
            scenario 'books unsuccessfully' do
              fill_in 'order_bookings_0_number_of_players', with: ''
              click_on 'Complete Reservation'
              expect(page).to have_content "can't be blank"
            end
          end
          context 'number of players is not an integer' do
            context 'number of players is string' do
              scenario 'books unsuccessfully' do
                fill_in 'order_bookings_0_number_of_players', with: 'hello'
                click_on 'Complete Reservation'
                expect(page).to have_content "is not a number"
              end
            end
            context 'number of players is floating point' do
              scenario 'books unsuccessfully' do
                fill_in 'order_bookings_0_number_of_players', with: '1.5'
                click_on 'Complete Reservation'
                expect(page).to have_content "must be an integer"
              end
            end
          end
          context 'number of players is less than zero' do
            scenario 'books unsuccessfully' do
              fill_in 'order_bookings_0_number_of_players', with: '-1'
              click_on 'Complete Reservation'
              expect(page).to have_content "must be greater than 0"
            end
          end
        end
      end
    end

    context 'books multiple time slots' do
      scenario 'displays the booking info correctly' do
        visit root_path
        search_activities
        click_on '09:00'
        click_on '10:00'
        click_on 'Book'
        expect(page).to have_content 'Monday, January 20'
        expect(page).to have_content @bowling.name
        expect(page).to have_content '9:00 AM - 10:00 AM'
        expect(page).to have_content '10:00 AM - 11:00 AM'
        expect(page).to have_content '0/30'
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
        expect(find_field('order_bookings_1_number_of_players').value).to eq '1'
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            visit root_path
            search_activities
            click_on '09:00'
            click_on '10:00'
            click_on 'Book'
            stub_stripe_checkout_handler
            click_on 'Complete Reservation'
            expect(page).to have_content 'Thank you for your purchase'
          end
        end
      end
    end

    context 'does not book any time slots' do
      scenario 'books unsuccessfully' do
        visit root_path
        click_on 'Search'
        click_on 'Book'
        expect(page).to have_content 'Please select at least one time slot.'
      end
    end
  end

  describe 'booking a room' do
    background do
      @laser_tag = create(:laser_tag, business: @business)
      @room = create(:room, activity: @laser_tag)
    end

    context 'books one time slot' do
      scenario 'displays the booking info correctly' do
        visit root_path
        search_activities(activity_type: 'Laser tag')
        click_on '11:00'
        click_on 'Book'

        expect(page).to have_content 'Monday, January 20'
        expect(page).to have_content @laser_tag.name
        expect(page).to have_content '11:00 AM - 12:00 PM'
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
        expect(page).to have_content "(0/30)"
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            visit root_path
            search_activities(activity_type: 'Laser tag')
            click_on '11:00'
            click_on 'Book'

            stub_stripe_checkout_handler

            click_on 'Complete Reservation'
            expect(page).to have_content 'Thank you for your purchase'
          end
        end

        xcontext 'params are invalid' do
          # TODO: This will have to be validated on the front end now
          # because stripe will need these numbers.
          context 'number of players is missing' do
            scenario 'books unsuccessfully' do
              fill_in 'order_bookings_0_number_of_players', with: ''
              click_on 'Complete Reservation'
              expect(page).to have_content "can't be blank"
            end
          end
          context 'number of players is not an integer' do
            context 'number of players is string' do
              scenario 'books unsuccessfully' do
                fill_in 'order_bookings_0_number_of_players', with: 'hello'
                click_on 'Complete Reservation'
                expect(page).to have_content "is not a number"
              end
            end
            context 'number of players is floating point' do
              scenario 'books unsuccessfully' do
                fill_in 'order_bookings_0_number_of_players', with: '1.5'
                click_on 'Complete Reservation'
                expect(page).to have_content "must be an integer"
              end
            end
          end
          context 'number of players is less than zero' do
            scenario 'books unsuccessfully' do
              fill_in 'order_bookings_0_number_of_players', with: '-1'
              click_on 'Complete Reservation'
              expect(page).to have_content "must be greater than 0"
            end
          end
          context 'number of players is over than available players' do
            scenario 'books unsuccessfully' do
              fill_in 'order_bookings_0_number_of_players', with: '15'
              click_on 'Complete Reservation'
              expect(page).to have_content 'must be fewer than available players'
            end
          end
        end
      end
    end

    context 'books multiple time slots' do
      scenario 'displays the booking info correctly' do
        visit root_path
        search_activities(activity_type: 'Laser tag')
        click_on '9:00'
        click_on '10:00'
        click_on 'Book'

        expect(page).to have_content 'Monday, January 20'
        expect(page).to have_content @laser_tag.name
        expect(page).to have_content '9:00 AM - 10:00 AM'
        expect(page).to have_content '10:00 AM - 11:00 AM'
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
        expect(find_field('order_bookings_1_number_of_players').value).to eq '1'
        expect(page).to have_content "(0/30)"
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            visit root_path
            search_activities(activity_type: 'Laser tag')
            click_on '9:00'
            click_on '10:00'
            click_on 'Book'

            stub_stripe_checkout_handler

            click_on 'Complete Reservation'
            expect(page).to have_content 'Thank you for your purchase'
          end
        end
      end
    end
  end

  def stub_stripe_checkout_handler
    page.execute_script(<<-JS)
      OPEN_PLAY.checkoutHandler = {
        open: function() {
          OPEN_PLAY.successfulChargeCallback({
            id: 'testId'
          });
        },
        close: function() {
          // NOOP
        }
      };
    JS
  end
end
