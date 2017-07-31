feature 'Reports' do
  context 'admin exists' do
    before {@user = create(:admin)}
    include_context 'logged in user'

    context 'Businesses exist' do
      before do
        @bowling = create(:business_with_bowling_activity, name: 'Major Bowl')
        create(:business_with_laser_tag_activity, name: 'Country Club')
      end
      scenario 'admin can filter by type' do
        enter_manage_orders_page
        expect_all_businesses_listed
        select_activity_type('Bowling')
        expect_businesses_with_bowling_activity_listed
      end

      context 'orders exist', js: true do
        before do
          activity = create(:bowling, business: @bowling)
          reservable = create(:reservable, activity: activity)
          @bookings = create_list(:booking, 2, booking_date: '2020-01-20',
                           reservable: reservable, booking_price: 40)
        end
        scenario 'admin can see order value' do
          enter_manage_orders_page
          select_date_range('20 Jan 2020', '21 Jan 2020')
          expect(page).to have_content '$200.00'
          @bookings[0].update(booking_date: '2020-01-25')
          select_date_range('20 Jan 2020', '21 Jan 2020')
          expect(page).to have_content '$100.00'
          first('tr.business').click
          expect(page).to have_content 'Valid'
          expect(page).to have_content '$100'
        end
      end
    end
  end

  context 'user exists' do
    before {@user = create(:user)}
    include_context 'logged in user'

    scenario 'user cannot check order' do
      visit root_path
      expect_cannot_check_order
    end
  end

  scenario 'anonymous cannot check order' do
    visit root_path
    expect_cannot_check_order
  end

  def enter_manage_orders_page
    visit root_path
    click_link 'Reports'
  end

  def expect_cannot_check_order
    expect(page).not_to have_content 'Reports'
  end

  def expect_all_businesses_listed
    expect(page).to have_content 'Major Bowl'
    expect(page).to have_content 'Country Club'
  end

  def expect_businesses_with_bowling_activity_listed
    expect(page).to have_content 'Major Bowl'
    expect(page).not_to have_content 'Country Club'
  end

  def expect_businesses_with_laser_tag_activity_listed
    expect(page).not_to have_content 'Major Bowl'
    expect(page).to have_content 'Country Club Laser Tag'
  end

  def fill_in_from_date(from_date)
    fill_in 'order_filter[from_date]', with: from_date || '20 Jan 2020'
  end

  def fill_in_to_date(to_date)
    fill_in 'order_filter[to_date]', with: to_date || '21 Jan 2020'
  end

  def select_date_range(from_date, to_date)
    fill_in_from_date('20 Jan 2020')
    fill_in_to_date('21 Jan 2020')
    click_link_or_button 'Filter'
  end

  def select_activity_type(activity_type)
    select activity_type, from: "order_filter[activity_type]"
    click_link_or_button 'Filter'
  end
end
