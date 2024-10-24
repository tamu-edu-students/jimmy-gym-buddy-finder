Rails.application.routes.draw do
  root "welcome#index"
  get "welcome/index", to: "welcome#index", as: "welcome"

  # SessionsController
  get "/logout", to: "sessions#logout", as: "logout"
  get "/auth/google_oauth2/callback", to: "sessions#omniauth"
  get "/auth/failure", to: "sessions#failure", as: "failure"

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # UsersController
  resources :users, only: [ :new, :create, :show, :edit, :update ] do
    member do
      get "dashboard", to: "dashboard#show"
      get "profile", to: "profiles#show"
    end
    resource :fitness_profile, only: [ :new, :create, :show, :edit, :update ]
  end

  get "matching/profileswipe", to: "matching#profileswipe", as: "profileswipe"
end
