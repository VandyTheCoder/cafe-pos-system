Rails.application.routes.draw do
  root "homepage#index"
  get "chart_data" => "homepage#chart_data", as: :chart_data

  scope "auth" do
    devise_for :users
  end

  resources :pos, only: [ :index ] do
    collection do
      get :search
      get :queue
      post :check_out
      patch :in_progress
      patch :cancel
      patch :complete
    end
  end

  resources :users
  resources :products
  resources :categories
  resources :sales

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "up" => "rails/health#show", as: :rails_health_check
end
