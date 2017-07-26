describe MetaTagHelper do
  describe '#meta_tags' do
    it 'returns correct meta tags' do
      @meta_tags = helper.meta_tags(
        title: 'FastLane',
        type: 'website',
        url: 'https://openplay.io/',
        image: 'https://hello.com/test_image_url.jpg',
        description: 'Awesome'
      )

      expect(@meta_tags).to include('FastLane')
      expect(@meta_tags).to include('website')
      expect(@meta_tags).to include('https://openplay.io/')
      expect(@meta_tags).to include('https://hello.com/test_image_url.jpg')
      expect(@meta_tags).to include('Awesome')
    end
  end
end
