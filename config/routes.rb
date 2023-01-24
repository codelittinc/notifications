# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq' # mount Sidekiq::Web in your Rails app

  root 'application#index'
  resources :channel_messages, only: %i[create update]
  resources :direct_messages, only: :create
  resources :reactions, only: %i[index create]
  resources :users, only: :index

  namespace :oauth do
    get '/slack', to: 'slack#create'
  end

  namespace :api do
    get '/users', to: 'users#index'
    get '/channels', to: 'channels#index'
    get '/provider', to: 'provider_credentials#show'
  end

  # These below are necessary to keep backwards compatibility
  post '/channel-messages', to: 'channel_messages#create'
  patch '/channel-messages', to: 'channel_messages#update'
  post '/direct-messages', to: 'direct_messages#create'
end
