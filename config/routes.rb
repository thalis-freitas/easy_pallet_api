Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'auth#login'

      resources :users

      resources :products

      get '/all/products', to: 'products#all'

      resources :loads do
        resources :orders, only: [:index, :create]
      end

      resources :orders, only: [:show, :update, :destroy] do
        resources :order_products, only: [:index, :create]
      end

      resources :order_products, only: [:show, :update, :destroy]

      post '/import/users', to: 'import#users'
    end
  end
end
