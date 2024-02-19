# frozen_string_literal: true

Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?

  post '/graphql', to: 'graphql#execute'

  namespace :admin do
    resources :zones
    resources :settlements
    resources :dungeons
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

  #   namespace :api do
  #     namespace :v1 do
  #       resources :zones do
  #         member do
  #           get :history
  #         end
  #       end
  #       resources :monsters
  #       resources :items do
  #         collection do
  #           post :search
  #         end
  #         member do
  #           post :assign
  #           post :unassign
  #         end
  #       end
  #       resources :npcs
  #       resources :quests
  #       resources :quest_objectives
  #     end
  #   end

  # get 'up' => 'rails/health#show', as: :rails_health_check

  root to: proc { [404, {}, ['Not found.']] }
end
