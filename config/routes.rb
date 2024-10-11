Rails.application.routes.draw do
  root "homepage#index"

  scope "auth" do
    devise_for :users
  end

  resources :pos, only: [ :index ] do
    collection do
      get :search
      post :check_out
      get :queue
      patch :in_progress
      patch :cancel
      patch :complete
    end
  end

  resources :users
  resources :products
  resources :product_sizes
  resources :categories
  resources :sales

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "up" => "rails/health#show", as: :rails_health_check
end
