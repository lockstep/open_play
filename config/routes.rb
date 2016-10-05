Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users

  resources :businesses, only: [:new, :create], shallow: true do
    resources :activities, only: [:index, :new, :create] do
      resources :reservables, only: [:new, :create]
    end
  end

  resources :orders, only: [:new, :create]
  get 'activities/search', to: 'activities#search'
  get 'orders/success', to: 'orders#success'
end
