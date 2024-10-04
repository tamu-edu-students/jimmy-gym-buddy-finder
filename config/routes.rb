Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome/index', to: 'welcome#index', as: 'welcome'

  get "users/new"
  post "users/create"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '/logout', to: 'sessions#logout', as: 'logout'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :users, only: [ :new, :create, :show, :edit, :update ] do
    member do
      get "dashboard", to: "dashboard#show"
      get "profile", to: "profiles#show"
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
  resources :users, only: [ :new, :create ]
end
