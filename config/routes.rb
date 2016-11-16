Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :guests
    resources :businesses
    resources :bowlings
    resources :laser_tags
    resources :lanes
    resources :rooms
    resources :orders
    resources :bookings

    root to: "users#index"
  end

  root 'welcome#index'
  devise_for :users

  resources :businesses, only: [:new, :create, :edit, :update], shallow: true do
    resources :activities, only: [:index, :new, :create, :edit, :update, :destroy] do
      resources :reservables, only: [:new, :create,  :edit, :update, :destroy]
      resources :closed_schedules, only: [:index, :create]
    end
  end

  resources :orders, only: [:new, :create] do
    get :success, on: :member
  end
  get 'businesses/show', to: 'businesses#show'
  resources :users, only: [:show, :edit, :update]
  resources :closed_schedules, only: [:destroy]
  patch 'bookings/:id/check_in', to: 'bookings#check_in', as: 'booking_check_in'
  patch 'bookings/:id/cancel', to: 'bookings#cancel', as: 'booking_cancel'

  get 'prepare_complete_order', to: 'orders#prepare_complete_order'
  get 'activities/search', to: 'activities#search'
  get 'search', to: 'search#search'
  get 'search/paginate_reservables', to: 'search#paginate_reservables'
  get 'activities/:activity_id/reservations',
    to: 'orders#reservations_for_business_owner', as: 'business_owner_reservations'
  get 'users/:user_id/reservations', to: 'orders#reservations_for_users',
    as: 'user_reservations'
end
