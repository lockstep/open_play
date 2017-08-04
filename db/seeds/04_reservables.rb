activity = Activity.find_by(name: 'Country Club')

Reservable.where(name: 'Item 1').first_or_create do |reservable|
  reservable.type = 'Lane'
  reservable.start_time = '09:00:00'
  reservable.end_time = '17:00:00'
  reservable.interval = 60
  reservable.activity = activity
  reservable.maximum_players = 30
  reservable.weekday_price = Money.new(500, 'USD')
  reservable.weekend_price = Money.new(1000, 'USD')
  reservable.per_person_weekday_price = Money.new(1500, 'USD')
  reservable.per_person_weekend_price = Money.new(2000, 'USD')
end
