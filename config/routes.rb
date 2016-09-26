Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users

  resources :businesses, only: [:new, :create], shallow: true do
    resources :activities, only: [:index, :new, :create] do
      resources :reservables, only: [:new, :create]
    end
  end
  get 'activities/search', to: 'activities#search'
end
