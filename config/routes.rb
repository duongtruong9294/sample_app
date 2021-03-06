# frozen_string_literal: true

Rails.application.routes.draw do
  root "static_page#home"

  get "users/new"
  get "/help", to: "static_page#help"
  get "/about", to: "static_page#about"
  get "/contact", to: "static_page#contact"
  get "/signup", to: "users#new"
  get "sessions/new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :account_activations, only: :edit
  resources :password_resets, except: [:index, :show, :destroy]
  resources :microposts, only: %i(create destroy)
  resources :relationships, only: [:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
end
