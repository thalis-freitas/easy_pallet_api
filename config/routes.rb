Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'auth#login'

      resources :users, only: :index

      resources :products, except: :show

      resources :loads, except: :show do
        resources :orders, only: [:index, :create]
      end

      resources :orders, only: [:update, :destroy] do
        resources :order_products, only: [:index, :create]
      end

      resources :order_products, only: [:update, :destroy]
    end
  end
end
