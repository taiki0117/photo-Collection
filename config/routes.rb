Rails.application.routes.draw do
  root to: "toppages#index"
  
  get "signup", to: "users#new"     #新規作成URLを/signupにするため
  resources :users
end