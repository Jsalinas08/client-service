Rails.application.routes.draw do
  resources :clients, only: [:index, :show, :create, :update]
end
