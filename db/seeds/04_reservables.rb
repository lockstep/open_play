activity = Activity.find_by(name: 'Country Club')

Reservable.where(name: 'Item 1').first_or_create do |reservable|
  reservable.start_time = '09:00:00'
  reservable.end_time = '17:00:00'
  reservable.interval = 60
  reservable.activity = activity
  reservable.maximum_players = 30
  reservable.weekday_price = 5
  reservable.weekend_price = 10
  reservable.per_person_weekday_price = 15
  reservable.per_person_weekend_price = 20
end
