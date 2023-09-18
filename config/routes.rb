Rails.application.routes.draw do
  root "welcome#index"

  get "/dashboard", to: "users#show"
  resources :tasks, only: [:new, :index, :create, :show, :update, :destroy]

  get 'auth/:provider', to: 'sessions#create', as: "google_login"
  get 'auth/google_oauth2/callback',  to: 'sessions#create'

  get "logout", to: "sessions#destroy"
  
  resources :tasks, only: [:new, :index, :create]
  get '/set_theme', to: 'theme#update'
  
  get "/authenticate", to: "users#authenticate"
end
