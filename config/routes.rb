require 'sidekiq/web'
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root "homepage#index"
  devise_for :users
  resources :trades, only: [:index, :show]
  resources :settings, only: [:index]
  resources :items, only: [:index]
  resources :trade_settings, only: [:index, :create]
  resources :trade_messages, only: [:create, :destroy]
  resources :admin, only: [:index]
  resources :subscriptions, only: [:create, :destroy]
  resources :copy_trader, only: [:index, :create]
  resources :pwa_copy_trader, only: [:index, :create]

  get 'offline', to: 'homepage#offline', as: :offline
  get "/subscriptions/:subscription_id/enable_auto", to: "subscriptions#enable", as: 'e_autopricing'
  get "/subscriptions/:subscription_id/disable_auto", to: "subscriptions#disable", as: 'd_autopricing'

  get "/contact", to: "static_pages/contacts#index"
  get "/subscription", to: "static_pages/subscriptions#index", as: :expired_sub

  get ":username/prices", to: 'user/price_lists#show', as: :user_price_list
  get ":username/update_prices", to: 'user/price_lists#update_list', as: :update_user_price_list
  
  namespace :user do
    resources :items, only: [:index, :update, :create]
    resources :price_lists, only: [:index]
    resources :autoupdater, only: [:index, :create, :update]
    resources :prices, only: [:destroy]
    get "/:id/remove_categories/:category_id", to: "categories#remove_category", as: 'remove_category'
    get "/:id/add_categories/:category_id", to: "categories#add_category", as: 'add_category'
    
    get "all_items_adder", to: 'autoupdater#all_items_adder', as: :all_items_adder
    
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
