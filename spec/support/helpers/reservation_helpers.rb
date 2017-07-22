module ReservationHelpers

  def search_activities(overrides={})
    # TODO the booking date must be after the current date.
    # So I set this future date as a workaround, it needs to be fixed later.
    fill_in :booking_date, with: overrides[:booking_date] || '20 Jan 2020'
    fill_in :booking_time, with: overrides[:booking_time] || '11:00am'
    fill_in_daly_city_fields(overrides[:business_city])
    page.select overrides[:activity_type] || 'Bowling', from: :activity_type
    click_on 'Search'
  end

  def select_a_booking_date(date)
    page.execute_script("$('#reservations-booking-date').val('" + date + "').trigger('change')")
  end

  def fill_in_daly_city_fields(city)
    return if city != 'Daly City, CA, United States'
    find('.place-address', visible: false).set('Daly City, CA, USA')
    find('.place-latitude', visible: false).set('37.6879241')
    find('.place-longitude', visible: false).set('-122.47020789999999')
  end
end
