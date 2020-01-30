Rails.application.routes.draw do
  root to: "toppages#index"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  get "signup", to: "users#new"     #新規作成URLを/signupにするため
  resources :users do
    member do
      get :followings   #/users/:id/followingsというURLが生成される
      get :followers    #/users/:id/followersというURLが生成される
      get :likes        #/users/:id/likesというURLが生成される
    end
  end
  
  resources :posts, only: [:index, :new, :edit, :update, :create, :destroy]
  resources :relationships, only: [:create, :destroy] #フォロー／アンフォローできるようにする
  resources :favorites, only: [:create, :destroy]
end