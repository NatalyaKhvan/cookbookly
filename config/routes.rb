Rails.application.routes.draw do
  # Root path
  root "home#index"

  # Authentication routes
  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # Dashboard
  get "/dashboard", to: "dashboard#index"

  # Users
  resources :users

  # Recipes and nested reviews
  resources :recipes do
    resources :reviews
    resources :ingredient_recipes, only: [ :new, :create, :edit, :update, :destroy ]
  end

  # Other resources
  resources :categories
  resources :ingredients

  # Favorites routes for index and destroy
  resources :favorites, only: [ :index, :destroy ]

  # Favorites routes (explicit)
  post "/recipes/:recipe_id/favorite", to: "favorites#create", as: :favorite_recipe

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
