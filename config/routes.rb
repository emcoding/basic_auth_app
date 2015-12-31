Rails.application.routes.draw do

  root to: 'sessions#new'

  get 'inloggen', to: 'sessions#new', as: 'inloggen'
  get 'aanmelden', to: 'users#new', as: 'aanmelden'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users, only: [:new, :show, :create]
  resources :sessions, only: [:new, :create, :destroy]

end