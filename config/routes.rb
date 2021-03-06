Rails.application.routes.draw do
  root "tours#index"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "sessions/new"
  resources :users
  resources :tours, only: %i(index show) do
    resources :bookings, except: %i(index), shallow: true
    resources :reviews, except: %i(index), shallow: true
  end
  resources :reviews,  only: %i(index)
  resources :bookings, only: %i(index)
  resources :categories, only: %i(index show)
  namespace :admin do
    get "dasboard/index", to: "dasboard#index"
    patch "tours/status/:id", to: "tours#status", as: "status"
    resources :users
    resources :categories
    resources :tours
    resources :bookings
    resources :reviews
  end
end
