require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin } { mount Sidekiq::Web => '/sidekiq' }

  namespace :admin do
    resources :users
    resources :guests
    resources :businesses do
      get :export_bookings, on: :member
    end
    resources :bowlings
    resources :laser_tags
    resources :lanes
    resources :rooms
    resources :orders
    resources :bookings

    root to: "users#index"
  end

  namespace :report do
    resources :businesses, only: [:index]
  end

  root 'welcome#index'
  devise_for :users

  resources :businesses, except: [:destroy], shallow: true do
    resources :activities, only: [:index, :new, :create, :edit, :update, :destroy] do
      get :view_analytics, on: :member
      resources :reservables, only: [:new, :create,  :edit, :update, :destroy]
      resources :closed_schedules, only: [:index, :create]
      resources :rate_override_schedules, only: [:index, :create]
    end
  end

  resources :orders, only: [:new, :create] do
    get :success, on: :member
  end
  post 'reserver_order', to: 'orders#reserver_order'
  resources :users, only: [:show, :edit, :update]
  resources :closed_schedules, only: [:destroy]
  resources :rate_override_schedules, only: [:destroy]
  patch 'bookings/:id/check_in', to: 'bookings#check_in', as: 'booking_check_in'
  patch 'bookings/:id/cancel', to: 'bookings#cancel', as: 'booking_cancel'

  get 'prepare_complete_order', to: 'orders#prepare_complete_order'
  get 'get_order_prices', to: 'orders#get_order_prices'
  get 'check_payment_requirement', to: 'orders#check_payment_requirement'
  get 'activities/search', to: 'activities#search'
  get 'search', to: 'search#search'
  get 'search/paginate_reservables', to: 'search#paginate_reservables'
  get 'activities/:activity_id/reservations',
    to: 'orders#reservations_for_business_owner', as: 'business_owner_reservations'
  get 'activities/:activity_id/reserver',
    to: 'orders#reserver', as: 'business_owner_reserver'
  get 'users/:user_id/reservations', to: 'orders#reservations_for_users',
    as: 'user_reservations'
end
