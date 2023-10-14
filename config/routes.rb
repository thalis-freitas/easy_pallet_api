Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'auth#login'

      resources :users

      resources :products

      resources :loads do
        resources :orders, only: [:index, :create]
      end

      resources :orders, only: [:show, :update, :destroy] do
        resources :order_products, only: [:index, :create]
      end

      resources :order_products, only: [:show, :update, :destroy]
    end
  end
end
