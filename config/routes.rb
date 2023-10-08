Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :products, only: [:index]

      resources :loads, only: [:index, :create, :update, :destroy] do
        resources :orders, only: [:index, :create]
      end

      resources :orders, only: [:update, :destroy]
    end
  end
end
