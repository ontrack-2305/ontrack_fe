Rails.application.routes.draw do
  root "welcome#index"

  get "/dashboard", to: "users#show"

  get 'auth/:provider/callback',  to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')

  resources :tasks, only: [:new, :index, :create]
end
