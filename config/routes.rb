Rails.application.routes.draw do
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

  get 'prepare_complete_order', to: 'orders#prepare_complete_order'
  get 'activities/search', to: 'activities#search'
  get 'search', to: 'search#search'
  get 'search/more_reservables', to: 'search#get_more_reservables'
  get 'activities/:activity_id/reservations',
    to: 'orders#reservations_for_business_owner', as: 'business_owner_reservations'
  get 'users/:user_id/reservations', to: 'orders#reservations_for_users',
    as: 'user_reservations'
end
