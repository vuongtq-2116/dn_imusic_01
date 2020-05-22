Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users, only: %i(new create show)
    resources :account_activations, only: :edit
    namespace :admin do
      resources :users
      resources :categories
      resources :albums
      resources :songs
    end
    resources :categories, only: :index
    resources :albums, only: %i(index show)
    resources :songs, only: %i(index show) do
      resources :comments
    end
  end
end
