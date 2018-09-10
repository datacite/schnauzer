Rails.application.routes.draw do
  root :to => 'index#index'

  get 'repositories/suggest', :to => 'repositories#suggest'

  resources :index, only: [:index]
  resources :heartbeat, only: [:index]

  resources :repositories
end