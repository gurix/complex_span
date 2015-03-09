Rails.application.routes.draw do
  root 'home#index'

  resources :sessions, only: [:create, :index]
  resources :presentations, only: [:index]
end
