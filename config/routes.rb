Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/dashboard", to: "users#show"
  resources :tasks, only: [:new, :index, :create, :show, :update]
end
