namespace :user do
  task create_guest_user: :environment do
    User.create(email: 'guest-user@gmail.com', password: '123456')
  end
end
