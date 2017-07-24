business = Business.find_by(name: 'Disney Land')

Activity.where(name: 'Country Club').first_or_create do |activity|
  activity.start_time = '09:00:00'
  activity.end_time = '17:00:00'
  activity.prevent_back_to_back_booking = false
  activity.allow_multi_party_bookings = false
  activity.business = business
  activity.type = 'Bowling'
end
