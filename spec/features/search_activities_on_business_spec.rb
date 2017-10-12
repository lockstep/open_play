feature 'Search Activities On Business', js: true do
  before do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  context 'Bowling with lead_time exist' do
    before { @bowling = create(:bowling, business: @business, lead_time: 5) }

    context 'when booking_date is within the lead time window' do
      background do
        visit business_path(@bowling)
        date = Date.current + 3.days
        search_activities(booking_date: date.strftime('%d %b %Y'))
      end

      scenario 'the bowling will not show up in the search result' do
        expect(page).to_not have_content 'Country Club Lanes'
      end
    end

    context 'when booking_date exactly match the lead time window' do
      background do
        visit business_path(@bowling)
        date = Date.current + 5.days
        search_activities(booking_date: date.strftime('%d %b %Y'))
      end

      scenario 'the bowling will show up in the search result' do
        expect(page).to have_content 'Country Club Lanes'
      end
    end

    context 'when booking_date is outside the lead time window' do
      background do
        visit business_path(@bowling)
        date = Date.current + 8.days
        search_activities(booking_date: date.strftime('%d %b %Y'))
      end

      scenario 'the bowling will show up in the search result' do
        expect(page).to have_content 'Country Club Lanes'
      end
    end
  end


  def search_activities(overrides={})
    fill_in :booking_date, with: overrides[:booking_date] || '20 Jan 2020'
    fill_in :booking_time, with: overrides[:booking_time] || '11:00am'
    click_on 'Search'
  end
end
