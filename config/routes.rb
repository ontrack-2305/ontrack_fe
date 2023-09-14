Rails.application.routes.draw do
  root "welcome#index"

  get "/dashboard", to: "users#show"

  get "/auth/google_oauth2/callback", to: "sessions#create", as: "google_login"

  resources :tasks, only: [:new, :index, :create]
end
