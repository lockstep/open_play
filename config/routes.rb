Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users

  resources :businesses, only: [:new, :create] do
    resources :activities, only: [:index, :new, :create]
  end
  get 'activities/search', to: 'activities#search'
end
