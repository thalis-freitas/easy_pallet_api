Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :products, except: :show

      resources :loads, except: :show do
        resources :orders, only: [:index, :create]
      end

      resources :orders, only: [:update, :destroy]
    end
  end
end
