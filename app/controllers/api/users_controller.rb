# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate

    def index
      users = Rails.cache.fetch(users_cache_key, expires_in: 60.seconds) do
        Clients::Slack::User.new(provider_credential).list
      end

      render json: users
    end

    private

    def users_cache_key
      "slack_users_#{provider_credential.id}"
    end
  end
end
