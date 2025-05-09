Rails.application.routes.draw do
  root "home#index"

  resources :recipes do
    resources :reviews
  end
  resources :categories
  resources :ingredients
  resources :favorites
  resources :users
  resources :ingredient_recipes

  get "/dashboard", to: "dashboard#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
