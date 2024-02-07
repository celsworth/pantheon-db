# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :zones
    resources :monsters
    resources :items
    resources :npcs
    resources :quests
    resources :quest_objectives

    root to: 'zones#index'
  end

  resources :zones

  # get 'up' => 'rails/health#show', as: :rails_health_check
end
