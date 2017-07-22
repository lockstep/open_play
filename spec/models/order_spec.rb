describe Order do
  describe '#total_price' do
    context 'books on weekday and on weekend date' do
      it 'sum bookings price correctly' do
        @order = create(:order)
        # weekday booking ($ 75)
        create(:booking, order: @order, booking_date: '2016-10-19', number_of_players: 5)
        # weekend booking ($ 100)
        create(:booking, order: @order, booking_date: '2016-10-22', number_of_players: 5)
        @order.set_price_of_bookings
        @order.save
        # order fee ($ 1)
        total_price = @order.reload.total_price
        expect(total_price).to eq 191.0
      end
    end
  end

  describe '#made_by_business_owner?' do
    context 'user exists' do
      context 'order is made by business owner' do
        it 'returns true' do
          user = build(:user)
          business = build(:business, user: user)
          activity = build(:activity, business: business)
          order = build(:order, user: user, activity: activity)
          expect(order.made_by_business_owner?).to eq true
        end
      end

      context 'order is not made by business owner' do
        it 'returns false' do
          user = build(:user)
          business = build(:business, user: build(:user))
          activity = build(:activity, business: business)
          order = build(:order, user: user, activity: activity)
          expect(order.made_by_business_owner?).to eq false
        end
      end
    end

    context 'user does not exist' do
      it 'returns false' do
        order = build(:order, user: nil, guest: create(:guest))
        expect(order.made_by_business_owner?).to eq false
      end
    end
  end

  describe '#client_phone_number' do
    context 'user exists' do
      before do
        user = create(:user, phone_number: '+1 650-252-0000')
        @order = create(:order, user: user)
      end

      it 'returns user phone number' do
        expect(@order.client_phone_number).to eq '+1 650-252-0000'
      end
    end

    context 'guest exists' do
      before do
        guest = create(:guest, phone_number: '+1 655-252-0000')
        @order = create(:order, user: nil, guest: guest)
      end

      it 'returns guest phone number' do
        expect(@order.client_phone_number).to eq '+1 655-252-0000'
      end
    end
  end

  describe '#sms_message' do
    before do
      booking = create(:booking, booking_price: 100.5)
      @order = booking.order
    end

    it 'contains order id' do
      expect(@order.sms_message).to include("Order ID: #{@order.id}")
    end

    it 'contains date' do
      expect(@order.sms_message).to include('Saturday, February 3')
    end

    it 'contains booking place' do
      expect(@order.sms_message).to include('Country Club')
    end

    it 'contains order price' do
      expect(@order.sms_message).to include('$101.50')
    end
  end
end
