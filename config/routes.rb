Rails.application.routes.draw do
  get 'ratings/create'
  get 'ratings/update'
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :account_activations, only: :edit
    namespace :admin do
      resources :categories
      resources :albums
      resources :songs do
        get "/get_approve", to: "lyric_requests#get_approve"
        resources :lyric_requests, only: :update
      end
      resources :lyric_requests, only: %i(index update)
    end
    resources :categories, only: :index
    resources :albums, only: %i(index show)
    resources :songs, only: %i(index show) do
      resources :comments
      resources :favorite_songs, only: %i(create destroy)
      resources :ratings
      resources :lyric_requests, only: %i(create edit update)
    end
    resources :favorite_songs, only: :index
    devise_for :users
  end
end
