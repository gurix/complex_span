Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'home#index'

  resources :sessions, only: [:create, :index]
  resources :presentations, only: [:index]
  resources :retrieval_clicks, only: [:index]
  resources :retrievals, only: [:index]
  resources :logs, only: [:index]
end
