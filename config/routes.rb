# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :zones
    resources :monsters
    resources :items
    resources :stats
    resources :npcs
    resources :quests
    resources :quest_objectives

    root to: 'zones#index'
  end

  namespace :api do
    namespace :v1 do
      resources :zones
      resources :monsters
      resources :items
      resources :npcs
      resources :quests
      resources :quest_objectives
    end
  end

  # get 'up' => 'rails/health#show', as: :rails_health_check
end
