Rails.application.routes.draw do

  # Route to SignUp or Create new user. 
  post "/signup", to: "users#create"

  # Route to login by user credentials.
  post "/login", to: "sessions#create"

  # Route to check user is login or not.
  get "/authorized", to: "sessions#show"
  
  # Routes to create show update destroy and list Tasks.
  resources :tasks, only: [:index, :destroy, :create, :show, :update]
end
