feature 'Complete Reservation', :js do

  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  describe 'booking a lane' do
    background do
      @bowling = create(:bowling, business: @business)
      @lane = create(:lane, activity: @bowling)
      visit root_path
      page.execute_script("$('#datepicker').val('4/10/2016')")
      click_on 'Search'
    end

    context 'books one time slot' do
      background do
        click_on '09:00'
        click_on 'Book'
        stub_stripe_checkout_handler
      end

      scenario 'displays the booking info correctly' do
        expect(page).to have_content 'Tuesday, October 4'
        expect(page).to have_content @bowling.name
        expect(page).to have_content '9:00 AM - 10:00 AM'
        expect(page).to_not have_css('span.players-detail')
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
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
      background do
        click_on '09:00'
        click_on '10:00'
        click_on 'Book'
      end

      scenario 'displays the booking info correctly' do
        expect(page).to have_content 'Tuesday, October 4'
        expect(page).to have_content @bowling.name
        expect(page).to have_content '9:00 AM - 10:00 AM'
        expect(page).to have_content '10:00 AM - 11:00 AM'
        expect(page).to_not have_css('span.players-detail')
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
        expect(find_field('order_bookings_1_number_of_players').value).to eq '1'
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            stub_stripe_checkout_handler
            click_on 'Complete Reservation'
            expect(page).to have_content 'Thank you for your purchase'
          end
        end
      end
    end

    context 'does not book any time slots' do
      scenario 'books unsuccessfully' do
        click_on 'Book'
        expect(page).to have_content 'Please select at least one time slot.'
      end
    end
  end

  xdescribe 'booking a room' do
    background do
      @laser_tag = create(:laser_tag, business: @business)
      @room = create(:room, activity: @laser_tag)
    end

    context 'Bookings are existed' do
      background do
        create_list(:booking, 2,
          reservable: @room,
          start_time: '09:00',
          end_time: '10:00',
          booking_date: '2016-10-04'
        )
        create(:booking,
          reservable: @room,
          start_time: '10:00',
          end_time: '11:00',
          booking_date: '2016-10-04',
          number_of_players: 5
        )
        visit root_path
        page.execute_script("$('#datepicker').val('4/10/2016')")
        page.select 'Laser tag', :from => 'activity_type'
        click_on 'Search'
      end

      context 'books one time slot' do
        background do
          click_on '11:00'
          click_on 'Book'
          stub_stripe_checkout_handler
        end

        scenario 'displays the booking info correctly' do
          expect(page).to have_content 'Tuesday, October 4'
          expect(page).to have_content @laser_tag.name
          expect(page).to have_content '11:00 AM - 12:00 PM'
          expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
          expect(page).to have_css('span.players-detail')
          expect(page).to have_content "(20/30)"
        end

        context 'complete reservation' do
          context 'params are valid' do
            scenario 'books successfully' do
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
                expect(page).to have_content 'must be less than available players'
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
          expect(page).to have_content @laser_tag.name
          expect(page).to have_content '9:00 AM - 10:00 AM'
          expect(page).to have_content '10:00 AM - 11:00 AM'
          expect(page).to have_css('span.players-detail')
          expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
          expect(find_field('order_bookings_1_number_of_players').value).to eq '1'
          expect(page).to have_content "(20/30)"
          expect(page).to have_content "(5/30)"
        end

        context 'complete reservation' do
          context 'params are valid' do
            scenario 'books successfully' do
              stub_stripe_checkout_handler
              click_on 'Complete Reservation'
              expect(page).to have_content 'Thank you for your purchase'
            end
          end
        end
      end

      context 'does not book any time slots' do
        scenario 'books unsuccessfully' do
          click_on 'Book'
          expect(page).to have_content 'Please select at least one time slot.'
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
        }
      };
    JS
  end
end
