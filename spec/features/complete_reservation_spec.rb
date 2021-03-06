feature 'Complete Reservation', :js do
  include ActiveJob::TestHelper

  background do
    @business = create(:business)
    @user = create(:user)
  end
  include_context 'logged in user'

  describe 'booking a lane' do
    background do
      @bowling = create(:bowling, business: @business)
      @lane = create(:lane, activity: @bowling)
    end

    context 'books one time slot' do
      context 'books on the weekday' do
        scenario 'displays the booking info correctly' do
          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'

          expect(page).to have_content 'Monday, January 20'
          expect(page).to have_content @bowling.name
          expect(page).to have_content '11:00 AM - 12:00 PM'
          expect(page).to have_content '0/30'
          expect(page).to have_content '$5'
          expect(page).to have_content '$15'
          expect(page).to have_content 'Subtotal: $20'
          expect(page).to have_content 'Open Play Fee: $1'
          expect(page).to have_content 'Total: $21'
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
            click_on '11:00'
            click_on 'Book'
            expect(page).to have_content 'Bumper'
            expect(page).to have_content 'Handicap accessible'
          end

          scenario 'books with available options successfully' do
            expect(StripeCharger).to receive(:charge).with(
              an_instance_of(Money), String
            ).and_return(149)
            expect(SendConfirmationOrderService).to receive(:call).with(
              hash_including(order: an_instance_of(Order), confirmation_channel: 'email')
            )
            visit root_path
            search_activities
            click_on '11:00'
            click_on 'Book'
            check 'Bumper'
            check 'Handicap accessible'

            stub_stripe_checkout_handler

            click_on 'Complete Reservation'
            expect(page).to have_content 'Thank you for your reservation!'
            expect(page).to have_content 'Reservation Info'
            expect(page).to have_content 'Monday, January 20'
            expect(page).to have_content 'Country Club Lanes'
            expect(page).to have_content 'Tom Cruise'
          end
        end
      end

      xcontext 'books on the weekend' do
        scenario 'displays the booking info correctly' do
          visit root_path
          search_activities(booking_date: '28 Oct 2017')

          click_on '11:00'
          click_on 'Book'

          expect(page).to have_content 'Saturday, October 28'
          expect(page).to have_content @bowling.name
          expect(page).to have_content '11:00 AM - 12:00 PM'
          expect(page).to have_content '0/30'
          expect(page).to have_content '$10'
          expect(page).to have_content '$20'
          expect(page).to have_content 'Subtotal: $30'
          expect(page).to have_content 'Open Play Fee: $1'
          expect(page).to have_content 'Total: $31'
          expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
        end
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
          click_on '11:00'
          click_on 'Book'
          expect(page).to have_content 'Bumper'
          expect(page).to have_content 'Handicap accessible'
        end

        scenario 'books with available options successfully' do
          expect(StripeCharger).to receive(:charge).with(
            an_instance_of(Money), String
          ).and_return(149)
          expect(SendConfirmationOrderService).to receive(:call).with(
            hash_including(order: an_instance_of(Order), confirmation_channel: 'email')
          )

          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'
          check 'Bumper'
          check 'Handicap accessible'

          stub_stripe_checkout_handler

          click_on 'Complete Reservation'
          expect(page).to have_content 'Reservation Info'
          expect(page).to have_content 'Tom Cruise'
        end
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            expect(StripeCharger).to receive(:charge).with(
              an_instance_of(Money), String
            ).and_return(149)
            expect(SendConfirmationOrderService).to receive(:call).with(
              hash_including(order: an_instance_of(Order), confirmation_channel: 'email')
            )
            visit root_path
            search_activities
            click_on '11:00'
            click_on 'Book'

            stub_stripe_checkout_handler

            click_on 'Complete Reservation'
            expect(page).to have_content 'Reservation Info'
            expect(page).to have_content 'Tom Cruise'
          end
        end

        context 'params are invalid' do
          context 'number of players is missing' do
            scenario 'books unsuccessfully' do
              visit root_path
              search_activities
              click_on '11:00'
              click_on 'Book'
              fill_in 'order_bookings_0_number_of_players', with: ''
              click_on 'Complete Reservation'

              expect(page).to have_content "can't be blank"
            end
          end
        end
      end
    end

    context 'cancel reservation' do
      scenario 'redirect to root path' do
        visit root_path
        search_activities
        click_on '11:00'
        click_on 'Book'
        click_on 'Cancel'
          expect(page.current_path).to eq(root_path)
      end
    end

    context 'books multiple time slots' do
      scenario 'displays the booking info correctly' do
        visit root_path
        search_activities
        click_on '11:00'
        click_on '14:00'
        click_on 'Book'
        expect(page).to have_content 'Monday, January 20'
        expect(page).to have_content @bowling.name
        expect(page).to have_content '11:00 AM - 12:00 PM'
        expect(page).to have_content '02:00 PM - 03:00 PM'
        expect(page).to have_content '0/30'
        expect(page).to have_content '$5'
        expect(page).to have_content '$15'
        expect(page).to have_content 'Subtotal: $40'
        expect(page).to have_content 'Open Play Fee: $1'
        expect(page).to have_content 'Total: $41'
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
        expect(find_field('order_bookings_1_number_of_players').value).to eq '1'
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            expect(StripeCharger).to receive(:charge).with(
              an_instance_of(Money), String
            ).and_return(149)
            expect(SendConfirmationOrderService).to receive(:call).with(
              hash_including(order: an_instance_of(Order), confirmation_channel: 'email')
            )

            visit root_path
            search_activities
            click_on '11:00'
            click_on '12:00'
            click_on '13:00'
            click_on 'Book'

            stub_stripe_checkout_handler

            click_on 'Complete Reservation'
            expect(page).to have_content 'Reservation Info'
            expect(page).to have_content 'Tom Cruise'
            expect(page).to have_content '11:00 AM - 02:00 PM'
            expect(page).to have_content '$61'
          end
        end
      end
    end

    context 'does not book any time slots' do
      scenario 'books unsuccessfully' do
        visit root_path
        search_activities
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
      context 'books on the weekday' do
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
          expect(page).to have_content '$5'
          expect(page).to have_content '$15'
          expect(page).to have_content 'Subtotal: $20'
          expect(page).to have_content 'Open Play Fee: $1'
          expect(page).to have_content 'Total: $21'
        end
      end

      xcontext 'books on the weekend' do
        scenario 'displays the booking info correctly' do
          visit root_path
          search_activities(activity_type: 'Laser tag', booking_date: '28 Oct 2017')
          click_on '11:00'
          click_on 'Book'

          expect(page).to have_content 'Saturday, October 28'
          expect(page).to have_content @laser_tag.name
          expect(page).to have_content '11:00 AM - 12:00 PM'
          expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
          expect(page).to have_content "(0/30)"
          expect(page).to have_content '$10'
          expect(page).to have_content '$20'
          expect(page).to have_content 'Subtotal: $30'
          expect(page).to have_content 'Open Play Fee: $1'
          expect(page).to have_content 'Total: $31'
        end
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            expect(StripeCharger).to receive(:charge).with(
              an_instance_of(Money), String
            ).and_return(149)
            expect(SendConfirmationOrderService).to receive(:call).with(
              hash_including(order: an_instance_of(Order), confirmation_channel: 'email')
            )
            visit root_path
            search_activities(activity_type: 'Laser tag')
            click_on '11:00'
            click_on 'Book'

            stub_stripe_checkout_handler

            click_on 'Complete Reservation'
            expect(page).to have_content 'Reservation Info'
            expect(page).to have_content 'Tom Cruise'
          end
        end

        context 'params are invalid' do
          context 'number of players is missing' do
            scenario 'books unsuccessfully' do
              visit root_path
              search_activities(activity_type: 'Laser tag')
              click_on '11:00'
              click_on 'Book'
              fill_in 'order_bookings_0_number_of_players', with: ''
              click_on 'Complete Reservation'

              expect(page).to have_content "can't be blank"
            end
          end
        end
      end
    end

    context 'books multiple time slots' do
      scenario 'displays the booking info correctly' do
        visit root_path
        search_activities(activity_type: 'Laser tag')
        click_on '11:00'
        click_on '14:00'
        click_on 'Book'

        expect(page).to have_content 'Monday, January 20'
        expect(page).to have_content @laser_tag.name
        expect(page).to have_content '11:00 AM - 12:00 PM'
        expect(page).to have_content '02:00 PM - 03:00 PM'
        expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
        expect(find_field('order_bookings_1_number_of_players').value).to eq '1'
        expect(page).to have_content "(0/30)"
        expect(page).to have_content '$5'
        expect(page).to have_content '$15'
        expect(page).to have_content 'Subtotal: $40'
        expect(page).to have_content 'Open Play Fee: $1'
        expect(page).to have_content 'Total: $41'
      end

      context 'complete reservation' do
        context 'params are valid' do
          scenario 'books successfully' do
            expect(StripeCharger).to receive(:charge).with(
              an_instance_of(Money), String
            ).and_return(149)
            expect(SendConfirmationOrderService).to receive(:call).with(
              hash_including(order: an_instance_of(Order), confirmation_channel: 'email')
            )

            visit root_path
            search_activities(activity_type: 'Laser tag')
            click_on '11:00'
            click_on '12:00'
            click_on '13:00'
            click_on 'Book'

            stub_stripe_checkout_handler

            click_on 'Complete Reservation'
            expect(page).to have_content 'Reservation Info'
            expect(page).to have_content 'Tom Cruise'
            expect(page).to have_content '11:00 AM - 02:00 PM'
            expect(page).to have_content '$61'
          end
        end
      end
    end
  end

  context 'confirmation message' do
    scenario 'receives email confirmation' do
      expect(StripeCharger).to receive(:charge).with(
        an_instance_of(Money), String
      ).and_return(149)
      expect(SendConfirmationOrderService).to receive(:call).with(
        hash_including(order: an_instance_of(Order), confirmation_channel: 'email')
      )

      @bowling = create(:bowling, business: @business)
      @lane = create(:lane, activity: @bowling)

      visit root_path
      search_activities
      click_on '11:00'
      click_on 'Book'
      choose 'confirmation_channel_email'
      stub_stripe_checkout_handler
      click_on 'Complete Reservation'

      expect(page).to have_content 'You will receive an email confirmation shortly.'
    end

    scenario 'receives sms confirmation' do
      expect(StripeCharger).to receive(:charge).with(
        an_instance_of(Money), String
      ).and_return(149)
      expect(SendConfirmationOrderService).to receive(:call).with(
        hash_including(order: an_instance_of(Order), confirmation_channel: 'sms')
      )

      @bowling = create(:bowling, business: @business)
      @lane = create(:lane, activity: @bowling)

      visit root_path
      search_activities
      click_on '11:00'
      click_on 'Book'
      choose 'confirmation_channel_sms'
      stub_stripe_checkout_handler
      click_on 'Complete Reservation'

      expect(page).to have_content 'You will receive a text confirmation shortly.'
    end
  end

  scenario 'stripe cannot charges money' do
    stripe = Stripe::CardError.new('Stripe Error', {}, 500)
    expect(StripeCharger).to receive(:charge).with(
      an_instance_of(Money), String
    ).and_raise(stripe)

    @bowling = create(:bowling, business: @business)
    @lane = create(:lane, activity: @bowling)

    visit root_path
    search_activities
    click_on '11:00'
    click_on 'Book'
    choose 'confirmation_channel_sms'
    stub_stripe_checkout_handler
    click_on 'Complete Reservation'

    expect(page).to have_content 'Stripe Error'
  end
end
