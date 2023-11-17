Rails.application.routes.draw do
  resources :games
  resources :users, only: [:index, :create]
  resources :games, only: [:create, :update]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#index"
end
