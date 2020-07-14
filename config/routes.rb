require 'sidekiq/web'
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root "homepage#index"
  devise_for :users
  resources :trades, only: [:index, :show]
  resources :settings, only: [:index]
  resources :items, only: [:index]
  resources :trade_settings, only: :index
  resources :trade_messages, only: [:create, :destroy]
  resources :admin, only: [:index]
  resources :subscriptions, only: [:create, :destroy]
  
  get "/subscriptions/:subscription_id/enable_auto", to: "subscriptions#enable", as: 'e_autopricing'
  get "/subscriptions/:subscription_id/disable_auto", to: "subscriptions#disable", as: 'd_autopricing'

  get "/contact", to: "static_pages/contacts#index"
  get ":username/prices", to: 'user/price_lists#show', as: :user_price_list
  get ":username/update_prices", to: 'user/price_lists#update_list', as: :update_user_price_list
  
  namespace :user do
    resources :items, only: [:index, :update, :create]
    resources :price_lists, only: [:index]
    resources :autoupdater, only: [:index, :create, :update]

    get "/:id/autoupdater/disable_global_pricing", to: "autoupdater#disable_global", as: 'disable_global_pricing'
    get "/:id/autoupdater/enable_global_pricing", to: "autoupdater#enable_global", as: 'enable_global_pricing'
  end

  namespace :api do 
    namespace :v1 do
      resources :trades, only: [:index, :show, :create]
      resources :users, only: [:create]
    end
  end

  mount Sidekiq::Web, at: "/sidekiq"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == "test123" && password == "test123"
  end
end
