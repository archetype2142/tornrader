# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root "homepage#index"
  devise_for :users
  resources :trades, only: [:index, :show]
  resources :settings, only: [:index]
  resources :items, only: [:index]
  
  get "/contact", to: "static_pages/contacts#index"
  get ":username/prices", to: 'user/price_lists#show', as: :user_price_list
  get ":username/update_prices", to: 'user/price_lists#update_list', as: :update_user_price_list
  namespace :user do
    resources :items, only: [:index, :update, :create]
    resources :price_lists, only: [:index]
  end


  namespace :api do 
    namespace :v1 do
      resources :trades, only: [:index, :show]
    end
  end
end
