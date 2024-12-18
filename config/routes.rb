Rails.application.routes.draw do
  get "messages/create"
  get "conversations/show"
  root "welcome#index"
  get "welcome/index", to: "welcome#index", as: "welcome"

  # SessionsController
  get "/logout", to: "sessions#logout", as: "logout"
  get "/auth/google_oauth2/callback", to: "sessions#omniauth"
  get "/auth/failure", to: "sessions#failure", as: "failure"
  get "/favicon.ico", to: ->(_) { [ 204, {}, [] ] }
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

  get "matching/:user_id/profileswipe", to: "matching#profileswipe", as: "matching_profileswipe"
  get "users/:user_id/prospective_users", to: "user_matches#prospective_users"


  # Routes for handling user actions on prospective users
  get "users/:user_id/match/:prospective_user_id", to: "user_matches#match"
  post "users/:user_id/skip/:prospective_user_id", to: "user_matches#skip"
  post "users/:user_id/block/:prospective_user_id", to: "user_matches#block", as: "block_user"

  resources :users do
    resources :notifications, only: [ :index, :create ] do
      member do
        post "mark_as_read", to: "notifications#mark_as_read"
        post "mark_as_unread", to: "notifications#mark_as_unread"
      end
    end
  end

  get "buddies", to: "buddies#index", as: "buddies"
  get "chatrooms/:buddy_name", to: "chatrooms#show", as: "chatroom"

  get "users/:user_id/matched_users", to: "user_matches#matched_users", as: "matched_users"
  post "users/:user_id/matched_users/block/:prospective_user_id", to: "user_matches#block_from_profile", as: "block_from_profile_user"
  get "users/:user_id/matched_users/profile/:id", to: "matched_users#show", as: "user_matched_user_profile"

  resources :users do
    member do
      get "chat/:id", to: "conversations#show", as: :chat
    end
  end

  resources :conversations, only: [ :show ] do
    resources :messages, only: [ :create ]
  end

  mount ActionCable.server => "/cable"
end
