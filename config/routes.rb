Rails.application.routes.draw do
  root "welcome#index"

  get "/dashboard", to: "users#show"
  resources :tasks, only: [:new, :index, :create, :show, :update, :destroy]

  get 'auth/:provider', to: 'sessions#create', as: "google_login"
  get 'auth/google_oauth2/callback',  to: 'sessions#create'

  resources :tasks, only: [:new, :index, :create]
end
