Rails.application.routes.draw do
  root 'home#index'

  resources :sessions, only: [:create, :index]
  resources :presentations, only: [:index]
  resources :retrieval_clicks, only: [:index]
end
