Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users

  resources :businesses, only: [:new, :create], shallow: true do
    resources :activities, only: [:index, :new, :create] do
      resources :reservables, only: [:new, :create]
    end
  end

  resources :orders, only: [:new, :create]
  get 'prepare_complete_order', to: 'orders#prepare_complete_order'
  get 'activities/search', to: 'activities#search'
  get 'orders/success', to: 'orders#success'
  get 'search', to: 'search#search'
  get 'activities/:activity_id/reservations',
    to: 'orders#reservations_for_business_owner', as: 'business_owner_reservations'
  get 'users/:user_id/reservations', to: 'orders#reservations_for_users',
    as: 'user_reservations'
end
