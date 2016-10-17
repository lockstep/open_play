module ReservationHelpers

  def search_activities(overrides={})
    # TODO the booking date must be after the current date.
    # So I set this future date as a workaround, it needs to be fixed later.
    fill_in :booking_date, with: overrides[:booking_date] || '20/01/2020'
    fill_in :booking_time, with: overrides[:booking_time] || '09:00am'
    page.select overrides[:activity_type] || 'Bowling', from: :activity_type
    click_on 'Search'
  end
end
