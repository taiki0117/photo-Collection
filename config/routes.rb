Rails.application.routes.draw do
  root to: "toppages#index"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  get "signup", to: "users#new"     #新規作成URLを/signupにするため
  resources :users
  
  resources :posts, only: [:edit, :create, :destroy]
end