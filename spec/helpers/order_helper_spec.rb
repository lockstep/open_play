describe OrderHelper do
  describe '#present_booking_price' do
    include MoneyRails::ActionViewExtension

    context 'booking_price is zero' do
      it 'displays booking_price correctly' do
        expect(present_booking_price(Money.new(0))).to eq '-'
      end
    end
    context 'booking_price is not zero' do
      it 'displays booking_price correctly' do
        expect(present_booking_price(Money.new(1550))).to eq '$15.50'
      end
      it 'displays booking_price correctly' do
        expect(present_booking_price(Money.new(1500))).to eq '$15'
      end
    end
  end

  describe '#able_to_change_status?' do
    context 'booking exists' do
      before do
        @booking = create(:booking)
      end
      context 'called by the correct action name' do
        before do
          @action_name = 'reservations_for_business_owner'
        end
        context 'a newly created booking' do
          it 'allows owner to change its status' do
            expect(able_to_change_status?(@action_name, @booking))
              .to eq true
          end
        end
        context 'booking is checked in' do
          before do
            @booking.update(checked_in: true)
          end
          it 'does not allow owner to change its status' do
            expect(able_to_change_status?(@action_name, @booking))
              .to eq false
          end
        end
        context 'booking is canceled' do
          before do
            @booking.update(canceled: true)
          end
          it 'does not allow owner to change its status' do
            expect(able_to_change_status?(@action_name, @booking))
              .to eq false
          end
        end
      end

      context 'called by a wrong action name' do
        before do
          @action_name = 'reservations_for_users'
        end
        it 'does not allow owner to change its status' do
          expect(able_to_change_status?(@action_name, @booking))
            .to eq false
        end
      end

    end
  end
end
