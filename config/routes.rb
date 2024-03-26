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

  resources :maps, only: %i[show] # elm

  resources :monsters, only: %i[index show edit update]

  resources :items, only: %i[index show edit update] do
    get 'dynamic_stats'
  end

  resources :locations, only: [] do
    get 'select_for_category', on: :collection, to: 'locations#select_for_category'
  end

  # get '/test', to: 'test#index'

  get '/login', to: 'users#login'
  post '/logout', to: 'users#logout'
  get '/oauth2/callback', to: 'users#oauth2_callback'

  # root to: proc { [404, {}, ['Not found.']] }
  root to: redirect('/maps/1')
end
