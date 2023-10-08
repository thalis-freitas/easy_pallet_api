Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :loads, only: [:index, :create, :update, :destroy] do
        resources :orders, only: [:index, :create]
      end
    end
  end
end
