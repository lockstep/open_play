describe OrderDecorator do
  describe '#social_media_title' do
    context 'activity type is a bowling' do
      before { @activity = build(:bowling) }

      it 'returns social_media_title' do
        order = build(:order, activity: @activity).decorate
        expect(order.social_media_title).to eq(
          'I just booked a round of bowling on OpenPlay at Country Club Lanes')
      end
    end

    context 'activity type is laser tag' do
      before { @activity = build(:laser_tag) }

      it 'returns social_media_title' do
        order = build(:order, activity: @activity).decorate
        expect(order.social_media_title).to eq(
          'I just booked a room of laser tag on OpenPlay at Country Club Laser Tag')
      end
    end
  end
end
