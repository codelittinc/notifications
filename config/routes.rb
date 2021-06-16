# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'application#index'
  resources :channel_messages, only: %i[create update],
                               defaults: { format: :json }
  resources :direct_messages, only: :create, defaults: { format: :json }
  resources :reactions, only: %i[index create], defaults: { format: :json }
  resources :users, only: :index, defaults: { format: :json }
end
