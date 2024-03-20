# frozen_string_literal: true

Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'

  post '/graphql', to: 'graphql#execute'

  namespace :admin do
    resources :users
    resources :zones
    resources :locations
    resources :monsters
    resources :items
    resources :npcs
    resources :quests
    resources :quest_objectives
    resources :quest_rewards
    resources :resources
    resources :images

    root to: 'zones#index'
  end

  post '/items/:item_id/image', controller: 'images', action: 'create'
  post '/monsters/:monster_id/image', controller: 'images', action: 'create'
  post '/npcs/:npc_id/image', controller: 'images', action: 'create'
  resources :images, only: %i[show]

  # get '/test', to: 'test#index'
  # resources :items, only: %i[new]

  resources :maps, only: %i[show]

  get '/login', to: 'users#login'
  post '/logout', to: 'users#logout'
  get '/oauth2/callback', to: 'users#oauth2_callback'

  # root to: proc { [404, {}, ['Not found.']] }
  root to: redirect('/maps/1')
end
