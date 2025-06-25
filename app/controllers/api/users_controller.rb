# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate

    def index
      begin
        users = Rails.cache.fetch(users_cache_key, expires_in: 10.minutes) do
          slack_users = Clients::Slack::User.new(provider_credential).list
          
          # Store backup cache for rate limit scenarios
          Rails.cache.write("#{users_cache_key}_backup", slack_users, expires_in: 24.hours)
          
          slack_users
        end

        render json: users
      rescue Slack::Web::Api::Errors::TooManyRequestsError => e
        # Try to serve backup cached data when rate limited
        backup_users = Rails.cache.read("#{users_cache_key}_backup")
        
        if backup_users.present?
          render json: backup_users
        else
          render json: { 
            error: 'Rate limited', 
            message: 'Slack API rate limit exceeded. Please try again in 60 seconds.',
            retry_after: 60
          }, status: :too_many_requests
        end
      rescue => e
        Rails.logger.error "UsersController error: #{e.class}: #{e.message}"
        render json: { 
          error: 'Internal server error', 
          message: e.message 
        }, status: :internal_server_error
      end
    end

    private

    def users_cache_key
      "slack_users_#{provider_credential.id}"
    end
  end
end
