Rails.application.routes.draw do
  root :to => 'index#index'

  get 'repositories/suggest', to: 'repositories#suggest'
  get "/repositories/:id/badge", to: "repositories#badge", format: :svg

  resources :index, only: [:index]
  resources :heartbeat, only: [:index]

  resources :repositories, constraints: { :id => /.+/ }
end