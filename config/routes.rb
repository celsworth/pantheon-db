# frozen_string_literal: true

Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?

  post '/graphql', to: 'graphql#execute'

  namespace :admin do
    resources :zones
    resources :locations
    resources :monsters
    resources :items
    resources :npcs
    resources :quests
    resources :quest_objectives
    resources :quest_rewards
    resources :resources

    root to: 'zones#index'
  end

  with_options controller: :images do
    resource :images, only: [] do
      resources :items, only: [] do
        get '/', action: :show
        post '/', action: :save
      end
      resources :monster, only: [] do
        get '/', action: :show
        post '/', action: :save
      end
    end
  end

  get '/test', to: 'test#index'

  resources :items, only: %i[new]
  resources :maps, only: %i[show]

  root to: proc { [404, {}, ['Not found.']] }
end
