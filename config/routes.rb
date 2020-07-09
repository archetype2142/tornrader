# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root "homepage#index"
  devise_for :users
  resources :trades, only: [:index, :show]
  resources :settings, only: [:index]
  resources :items, only: [:index]
  
  get "/contact", to: "static_pages/contacts#index"

  namespace :api do 
    namespace :v1 do
      resources :trades, only: :index
    end
  end
end
