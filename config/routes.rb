Rails.application.routes.draw do
  root 'sessions#new'
  resources :sessions, only: %i[new create destroy]
  resources :tasks
  resources :users, only: %i[new create show]
  
  namespace :admin do
    resources :users
  end
end
