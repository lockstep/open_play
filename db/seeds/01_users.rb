# admin
User.where(email: 'admin@example.com').first_or_create do |user|
  user.first_name = 'Admin'
  user.last_name = 'Team'
  user.password = 'password'
  user.phone_number = '+1 650-253-0000'
  user.admin = true
end

# business owner
User.where(email: 'user1@example.com').first_or_create do |user|
  user.first_name = 'Tom'
  user.last_name = 'Cruise'
  user.password = 'password'
  user.phone_number = '+1 650-253-0000'
end

User.where(email: 'user2@example.com').first_or_create do |user|
  user.first_name = 'Jan'
  user.last_name = 'Vandam'
  user.password = 'password'
  user.phone_number = '+1 650-253-0000'
end
