Rails.application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  root "static_page#home"
  delete "/unfriend", to: "friends#destroy"
  post "/search_name_document", to: "search_documents#search_name"
  post "/search_categories", to: "search_documents#search_category"
  post "/create_report", to:"comments#create"
  get "/search_report", to: "search_documents#search_reported"
  get "/search_deleted", to: "search_documents#search_deleted"

  resources :users
  resources :friends
  resources :documents do
    resources :comments, only: %i(create destroy)
  end
  resources :categories, only: :create
  resources :history_downloads, only: %i(index create)
  resources :transactions, only: :create
  resources :favorites, only: %i(index create destroy)
  resources :history_views, only: :index
  namespace :admin do
    resources :categories, only: %i(index destroy update)
    resources :users, only: %i(index destroy)
    resources :transactions, only: %i(index update destroy)
  end
end
