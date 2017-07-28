user1 = User.find_by(email: 'user1@example.com')
Business.where(name: 'Disney Land').first_or_create do |business|
  business.phone_number = 1234567890
  business.address = '123 building'
  business.description = 'amazing amusement park'
  business.user = user1
end

user2 = User.find_by(email: 'user2@example.com')
Business.where(name: 'Country Club').first_or_create do |business|
  business.phone_number = 1234567890
  business.address = '123 building'
  business.description = 'amazing amusement park'
  business.user = user2
end
