Rails.application.routes.draw do
  root :to => 'index#index'

  post "/re3data/graphql", to: "graphql#execute"
  get "/re3data/graphql", to: "index#method_not_allowed"
  get 're3data/suggest', to: 're3data#suggest'
  get "/re3data/:id/badge", to: "re3data#badge", format: :svg, constraints: { :id => /.+/ }

  resources :index, only: [:index]
  resources :heartbeat, only: [:index]

  resources :re3data, constraints: { :id => /.+/ }
end