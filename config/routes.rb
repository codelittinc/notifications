# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'application#index'
  resources :channel_messages, only: %i[create update]
  resources :direct_messages, only: :create
  resources :reactions, only: %i[index create]
  resources :users, only: :index

  post '/channel-messages', to: 'channel_messages#create'
  patch '/channel-messages', to: 'channel_messages#update'

  post '/direct-messages', to: 'direct_messages#create'
end
