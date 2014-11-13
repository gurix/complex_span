Rails.application.routes.draw do
  scope ':locale' do
    root 'home#index'
  end
end
