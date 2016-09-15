Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users

  resources :businesses, only: [:index, :new, :create] do
    resources :activities, only: [:index, :new, :create]
  end
end
