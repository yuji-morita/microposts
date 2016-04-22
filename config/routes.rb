Rails.application.routes.draw do
  root to: 'static_pages#home'
  get    'signup', to: 'users#new'
  get    'login' , to: 'sessions#new'
  post   'login' , to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers, :preference, :matching, :create_preference
    end
  end
  
  get 'resp', to: 'microposts#resp'
  get 'check', to: 'microposts#check'
  
  resources :users
  resources :microposts
  resources :relationships, only: [:create, :destroy]
  resources :response_relations, only: [:create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]

end