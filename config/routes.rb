Rails.application.routes.draw do

  get 'inloggen', to: 'sessions#new', as: 'inloggen'
  get 'aanmelden', to: 'users#new', as: 'aanmelden'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  root to: 'users#new'
  resources :users
  resources :sessions

end