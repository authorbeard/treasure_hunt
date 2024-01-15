Rails.application.routes.draw do
  resources :games
  resources :users, only: [:index, :create]
  resources :games, only: [:create, :update]

  get '/winners', to: 'users#index', defaults: { filter: 'winners' }

  namespace :admin do
    resources :users, only: [:index, :create]
  end
  
  root "users#index"
end
