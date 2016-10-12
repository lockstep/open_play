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
    end

    context 'books one time slot' do
      scenario 'displays the booking info correctly' do
        visit root_path
        page.execute_script("$('#datepicker').val('4/10/2016')")
        page.select 'Bowling', :from => 'activity_type'
        click_on 'Search'
        click_on '09:00'
        click_on 'Book'

        stub_stripe_checkout_handler

        expect(page).to have_content 'Tuesday, October 4'
        expect(page).to have_content @bowling.name
        expect(page).to have_content '9:00 AM - 10:00 AM'
        expect(page).to have_content '0/30'
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            visit root_path
            page.execute_script("$('#datepicker').val('4/10/2016')")
            page.select 'Bowling', :from => 'activity_type'
            click_on 'Search'
            click_on '09:00'
            click_on 'Book'

            stub_stripe_checkout_handler

            click_on 'Complete Reservation'
            expect(page).to have_content 'Thank you for your purchase'
          end
        end

        context 'params are invalid' do
          context 'number of players is missing' do
            scenario 'books unsuccessfully' do
              visit root_path
              page.execute_script("$('#datepicker').val('4/10/2016')")
              page.select 'Bowling', :from => 'activity_type'
              click_on 'Search'
              click_on '09:00'
              click_on 'Book'
              fill_in 'order_bookings_0_number_of_players', with: ''
              click_on 'Complete Reservation'

              expect(page).to have_content "can't be blank"
            end
          end
          context 'number of players is not an integer' do
            context 'number of players is string' do
              scenario 'books unsuccessfully' do
                visit root_path
                page.execute_script("$('#datepicker').val('4/10/2016')")
                page.select 'Bowling', :from => 'activity_type'
                click_on 'Search'
                click_on '09:00'
                click_on 'Book'
                fill_in 'order_bookings_0_number_of_players', with: 'hello'
                click_on 'Complete Reservation'

                expect(page).to have_content "is not a number"
              end
            end
            context 'number of players is floating point' do
              scenario 'books unsuccessfully' do
                visit root_path
                page.execute_script("$('#datepicker').val('4/10/2016')")
                page.select 'Bowling', :from => 'activity_type'
                click_on 'Search'
                click_on '09:00'
                click_on 'Book'
                fill_in 'order_bookings_0_number_of_players', with: '1.5'
                click_on 'Complete Reservation'

                expect(page).to have_content "must be an integer"
              end
            end
          end
          context 'number of players is less than zero' do
            scenario 'books unsuccessfully' do
              visit root_path
              page.execute_script("$('#datepicker').val('4/10/2016')")
              page.select 'Bowling', :from => 'activity_type'
              click_on 'Search'
              click_on '09:00'
              click_on 'Book'
              fill_in 'order_bookings_0_number_of_players', with: '-1'
              click_on 'Complete Reservation'

              expect(page).to have_content "must be greater than 0"
            end
          end
          # TODO (after search funcationlity complete)
          # to validate number_of_players in case of bookings exist
          context 'number of players is over than available players' do
            scenario 'books unsuccessfully' do
              visit root_path
              page.execute_script("$('#datepicker').val('4/10/2016')")
              page.select 'Bowling', :from => 'activity_type'
              click_on 'Search'
              click_on '09:00'
              click_on 'Book'
              fill_in 'order_bookings_0_number_of_players', with: '35'
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
        page.execute_script("$('#datepicker').val('4/10/2016')")
        page.select 'Bowling', :from => 'activity_type'
        click_on 'Search'
        click_on '09:00'
        click_on '10:00'
        click_on 'Book'

        expect(page).to have_content 'Tuesday, October 4'
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
            page.execute_script("$('#datepicker').val('4/10/2016')")
            page.select 'Bowling', :from => 'activity_type'
            click_on 'Search'
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
        page.execute_script("$('#datepicker').val('4/10/2016')")
        page.select 'Bowling', :from => 'activity_type'
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
        page.execute_script("$('#datepicker').val('4/10/2016')")
        page.select 'Laser tag', :from => 'activity_type'
        click_on 'Search'
        click_on '11:00'
        click_on 'Book'

        expect(page).to have_content 'Tuesday, October 4'
        expect(page).to have_content @laser_tag.name
        expect(page).to have_content '11:00 AM - 12:00 PM'
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
        expect(page).to have_content "(0/30)"
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            visit root_path
            page.execute_script("$('#datepicker').val('4/10/2016')")
            page.select 'Laser tag', :from => 'activity_type'
            click_on 'Search'
            click_on '11:00'
            click_on 'Book'

            stub_stripe_checkout_handler

            click_on 'Complete Reservation'
            expect(page).to have_content 'Thank you for your purchase'
          end
        end

        context 'params are invalid' do
          context 'number of players is missing' do
            scenario 'books unsuccessfully' do
              visit root_path
              page.execute_script("$('#datepicker').val('4/10/2016')")
              page.select 'Laser tag', :from => 'activity_type'
              click_on 'Search'
              click_on '11:00'
              click_on 'Book'
              fill_in 'order_bookings_0_number_of_players', with: ''
              click_on 'Complete Reservation'

              expect(page).to have_content "can't be blank"
            end
          end
          context 'number of players is not an integer' do
            context 'number of players is string' do
              scenario 'books unsuccessfully' do
                visit root_path
                page.execute_script("$('#datepicker').val('4/10/2016')")
                page.select 'Laser tag', :from => 'activity_type'
                click_on 'Search'
                click_on '11:00'
                click_on 'Book'
                fill_in 'order_bookings_0_number_of_players', with: 'hello'
                click_on 'Complete Reservation'

                expect(page).to have_content "is not a number"
              end
            end
            context 'number of players is floating point' do
              scenario 'books unsuccessfully' do
                visit root_path
                page.execute_script("$('#datepicker').val('4/10/2016')")
                page.select 'Laser tag', :from => 'activity_type'
                click_on 'Search'
                click_on '11:00'
                click_on 'Book'
                fill_in 'order_bookings_0_number_of_players', with: '1.5'
                click_on 'Complete Reservation'

                expect(page).to have_content "must be an integer"
              end
            end
          end
          context 'number of players is less than zero' do
            scenario 'books unsuccessfully' do
              visit root_path
              page.execute_script("$('#datepicker').val('4/10/2016')")
              page.select 'Laser tag', :from => 'activity_type'
              click_on 'Search'
              click_on '11:00'
              click_on 'Book'
              fill_in 'order_bookings_0_number_of_players', with: '-1'
              click_on 'Complete Reservation'

              expect(page).to have_content "must be greater than 0"
            end
          end
          # TODO (after search funcationlity complete)
          # to validate number_of_players in case of bookings exist
          context 'number of players is over than available players' do
            scenario 'books unsuccessfully' do
              visit root_path
              page.execute_script("$('#datepicker').val('4/10/2016')")
              page.select 'Laser tag', :from => 'activity_type'
              click_on 'Search'
              click_on '11:00'
              click_on 'Book'
              fill_in 'order_bookings_0_number_of_players', with: '35'
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
        page.execute_script("$('#datepicker').val('4/10/2016')")
        page.select 'Laser tag', :from => 'activity_type'
        click_on 'Search'
        click_on '9:00'
        click_on '10:00'
        click_on 'Book'

        expect(page).to have_content 'Tuesday, October 4'
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
            page.execute_script("$('#datepicker').val('4/10/2016')")
            page.select 'Laser tag', :from => 'activity_type'
            click_on 'Search'
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
        }
      };
    JS
  end
end
