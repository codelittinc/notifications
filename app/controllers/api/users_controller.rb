# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate

    def index
      users = fetch_users_with_cache
      render json: users
    rescue Slack::Web::Api::Errors::TooManyRequestsError
      handle_rate_limit_error
    rescue StandardError => e
      handle_general_error(e)
    end

    private

    def fetch_users_with_cache
      Rails.cache.fetch(users_cache_key, expires_in: 10.minutes) do
        slack_users = Clients::Slack::User.new(provider_credential).list
        store_backup_cache(slack_users)
        slack_users
      end
    end

    def store_backup_cache(slack_users)
      Rails.cache.write("#{users_cache_key}_backup", slack_users, expires_in: 24.hours)
    end

    def handle_rate_limit_error
      backup_users = Rails.cache.read("#{users_cache_key}_backup")

      if backup_users.present?
        render json: backup_users
      else
        render json: rate_limit_error_response, status: :too_many_requests
      end
    end

    def handle_general_error(error)
      Rails.logger.error "UsersController error: #{error.class}: #{error.message}"
      render json: general_error_response(error), status: :internal_server_error
    end

    def rate_limit_error_response
      {
        error: 'Rate limited',
        message: 'Slack API rate limit exceeded. Please try again in 60 seconds.',
        retry_after: 60
      }
    end

    def general_error_response(error)
      {
        error: 'Internal server error',
        message: error.message
      }
    end

    def users_cache_key
      "slack_users_#{provider_credential.id}"
    end
  end
end
