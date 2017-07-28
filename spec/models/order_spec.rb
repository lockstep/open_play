describe Order do
  describe '#total_price' do
    context 'books on weekday and on weekend date' do
      context 'order is made by business owner' do
        it 'sums bookings price correctly' do
          business_owner = create(:user)
          business = create(:business, user: business_owner)
          bowling = create(:bowling, business: business)
          order = create(:order, user: business_owner, activity_id: bowling.id)
          create(:booking, order: order, booking_date: '2016-10-19', number_of_players: 5)
          create(:booking, order: order, booking_date: '2016-10-22', number_of_players: 5)
          order.set_price_of_bookings
          order.save
          expect(order.reload.total_price).to eq 0
        end
      end

      context 'order is made by user' do
        it 'sums bookings price correctly' do
          user = create(:user)
          business_owner = create(:user)
          business = create(:business, user: business_owner)
          bowling = create(:bowling, business: business)
          order = create(:order, user: user, activity_id: bowling.id)
          create(:booking, order: order, booking_date: '2016-10-19', number_of_players: 5)
          create(:booking, order: order, booking_date: '2016-10-22', number_of_players: 5)
          order.set_price_of_bookings
          order.save
          # $ 75(weekday booking) + $ 100 (weekend booking)+ $ 1 (order fee)
          expect(order.reload.total_price).to eq 191.0
        end
      end
    end
  end

  describe '#sub_total_price' do
    it 'sums total price correctly' do
      order = build(:order)
      create(:booking, order: order, booking_price: 50)
      create(:booking, order: order, booking_price: 100)
      expect(order.sub_total_price).to eq(150)
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
