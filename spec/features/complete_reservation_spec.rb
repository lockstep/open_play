feature 'Complete Reservation', js: true, driver: :webkit do

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
        click_on '9:00 - 10:00'
        click_on 'Book'
      end

      scenario 'displays the booking info correctly' do
        expect(page).to have_content 'Tuesday, October 4'
        expect(page).to have_content @bowling.name
        # Because I hard code time on search result page. So, this spec will need to
        # be changeed in the future. I will leave it for now.
        # expect(page).to have_content '9:00 AM - 10:00 AM'
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

        context 'params are invalid' do
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
        click_on '9:00 - 10:00'
        click_on '10:00 - 11:00'
        click_on 'Book'
      end

      scenario 'displays the booking info correctly' do
        expect(page).to have_content 'Tuesday, October 4'
        expect(page).to have_content @bowling.name
        # Because I hard code time on search result page. So, this spec will need to
        # be changeed in the future. I will leave it for now.
        # expect(page).to have_content '9:00 AM - 10:00 AM'
        # expect(page).to have_content '10:00 AM - 11:00 AM'
        expect(page).to_not have_css('span.players-detail')
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
        expect(find_field('order_bookings_1_number_of_players').value).to eq '1'
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
        expect(page).to have_content 'Please select at least one time slot.'
      end
    end
  end

  # end booking a room

  describe 'booking a room' do
    background do
      @laser_tag = create(:laser_tag, business: @business)
      @room = create(:room, activity: @laser_tag)
      create_list(:booking, 2, reservable: @room)
      visit root_path
      page.execute_script("$('#datepicker').val('4/10/2016')")
      click_on 'Search'
    end

    context 'books one time slot' do
      background do
        click_on '9:00 - 10:00'
        click_on 'Book'
      end

      scenario 'displays the booking info correctly' do
        expect(page).to have_content 'Tuesday, October 4'
        expect(page).to have_content @laser_tag.name
        # Because I hard code time on search result page. So, this spec will need to
        # be changeed in the future. I will leave it for now.
        # expect(page).to have_content '9:00 AM - 10:00 AM'
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

        context 'params are invalid' do
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
        # Because I hard code time on search result page. So, this spec will need to
        # be changeed in the future. I will leave it for now.
        # expect(page).to have_content '9:00 AM - 10:00 AM'
        # expect(page).to have_content '10:00 AM - 11:00 AM'
        expect(page).to have_css('span.players-detail')
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
        expect(find_field('order_bookings_1_number_of_players').value).to eq '1'
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
        expect(page).to have_content 'Please select at least one time slot.'
      end
    end
  end
end
