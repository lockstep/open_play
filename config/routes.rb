Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users

  resources :businesses, only: [:new, :create]
  resources :activities, only: [:index]
end
