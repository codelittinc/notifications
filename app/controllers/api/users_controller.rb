# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate
    before_action :log_request_details
    before_action :test_cache_connectivity

    def index
      Rails.logger.info "[UsersController#index] Starting users fetch"
      Rails.logger.info "[UsersController#index] Provider credential ID: #{provider_credential&.id}"
      Rails.logger.info "[UsersController#index] Cache key: #{users_cache_key}"

      begin
        # Test if cache key already exists
        cache_exists = Rails.cache.exist?(users_cache_key)
        Rails.logger.info "[UsersController#index] Cache key exists: #{cache_exists}"
        
        if cache_exists
          cached_data = Rails.cache.read(users_cache_key)
          Rails.logger.info "[UsersController#index] Cached data present: #{cached_data.present?}"
          Rails.logger.info "[UsersController#index] Cached data size: #{cached_data&.size || 'N/A'}"
          Rails.logger.info "[UsersController#index] Cached data class: #{cached_data.class}"
        end

        users = Rails.cache.fetch(users_cache_key, expires_in: 60.seconds) do
          Rails.logger.info "[UsersController#index] === CACHE MISS - FETCHING FROM SLACK API ==="
          Rails.logger.info "[UsersController#index] About to call Slack API"
          
          slack_users = Clients::Slack::User.new(provider_credential).list
          
          Rails.logger.info "[UsersController#index] Slack API call completed"
          Rails.logger.info "[UsersController#index] Successfully fetched #{slack_users&.size || 0} users from Slack"
          Rails.logger.info "[UsersController#index] Slack users class: #{slack_users.class}"
          Rails.logger.info "[UsersController#index] About to cache data with key: #{users_cache_key}"
          
          # Log what we're about to cache
          Rails.logger.info "[UsersController#index] Caching data: #{slack_users&.first(2)&.to_json}" if slack_users&.any?
          
          slack_users
        end

        # Verify cache was written
        post_cache_exists = Rails.cache.exist?(users_cache_key)
        Rails.logger.info "[UsersController#index] After fetch - cache key exists: #{post_cache_exists}"
        
        if post_cache_exists
          post_cached_data = Rails.cache.read(users_cache_key)
          Rails.logger.info "[UsersController#index] After fetch - cached data size: #{post_cached_data&.size || 'N/A'}"
        end

        Rails.logger.info "[UsersController#index] Returning #{users&.size || 0} users from cache/API"
        Rails.logger.info "[UsersController#index] Final users class: #{users.class}"
        
        render json: users
      rescue => e
        Rails.logger.error "[UsersController#index] Error occurred: #{e.class}: #{e.message}"
        Rails.logger.error "[UsersController#index] Backtrace: #{e.backtrace.first(10).join('\n')}"
        Rails.logger.error "[UsersController#index] Provider credential present: #{provider_credential.present?}"
        Rails.logger.error "[UsersController#index] Provider credential details: #{provider_credential&.attributes&.except('access_token', 'refresh_token')}"
        
        # Check if it's a rate limit error and serve from cache if available
        if e.is_a?(Slack::Web::Api::Errors::TooManyRequestsError)
          Rails.logger.warn "[UsersController#index] Rate limited! Attempting to serve stale cache data"
          
          # Try to get any cached data, even if expired
          stale_cache_key = "#{users_cache_key}_stale"
          stale_users = Rails.cache.read(stale_cache_key)
          
          if stale_users.present?
            Rails.logger.info "[UsersController#index] Serving stale cache data with #{stale_users.size} users"
            render json: stale_users
          else
            Rails.logger.error "[UsersController#index] No stale cache available, returning rate limit error"
            render json: { 
              error: 'Rate limited', 
              message: 'Slack API rate limit exceeded. Please try again in 60 seconds.',
              retry_after: 60
            }, status: :too_many_requests
          end
        else
          render json: { 
            error: 'Internal server error', 
            message: e.message,
            type: e.class.name 
          }, status: :internal_server_error
        end
      end
    end

    private

    def users_cache_key
      "slack_users_#{provider_credential.id}"
    end

    def test_cache_connectivity
      Rails.logger.info "[UsersController] === TESTING REDIS CACHE CONNECTIVITY ==="
      
      begin
        # Test basic cache operations
        test_key = "test_cache_#{Time.current.to_i}"
        test_value = { test: true, timestamp: Time.current }
        
        Rails.logger.info "[UsersController] Testing cache write with key: #{test_key}"
        write_result = Rails.cache.write(test_key, test_value, expires_in: 30.seconds)
        Rails.logger.info "[UsersController] Cache write result: #{write_result}"
        
        Rails.logger.info "[UsersController] Testing cache read"
        read_result = Rails.cache.read(test_key)
        Rails.logger.info "[UsersController] Cache read result: #{read_result}"
        Rails.logger.info "[UsersController] Cache read successful: #{read_result == test_value}"
        
        Rails.logger.info "[UsersController] Testing cache exist"
        exist_result = Rails.cache.exist?(test_key)
        Rails.logger.info "[UsersController] Cache exist result: #{exist_result}"
        
        # Clean up test key
        Rails.cache.delete(test_key)
        Rails.logger.info "[UsersController] Test cache key deleted"
        
        # Test Redis connection info
        if Rails.cache.respond_to?(:redis)
          Rails.logger.info "[UsersController] Redis info: #{Rails.cache.redis.info('server')['redis_version']}"
        elsif defined?(Redis) && Rails.cache.is_a?(ActiveSupport::Cache::RedisCacheStore)
          Rails.logger.info "[UsersController] Using Redis cache store"
        end
        
        Rails.logger.info "[UsersController] Cache store class: #{Rails.cache.class}"
        Rails.logger.info "[UsersController] Redis URL: #{ENV['REDIS_URL']&.gsub(/:[^:]*@/, ':***@')}" # Hide password
        
      rescue => e
        Rails.logger.error "[UsersController] Cache connectivity test failed: #{e.class}: #{e.message}"
        Rails.logger.error "[UsersController] Cache test backtrace: #{e.backtrace.first(5).join('\n')}"
      end
      
      Rails.logger.info "[UsersController] === CACHE CONNECTIVITY TEST END ==="
    end

    def log_request_details
      Rails.logger.info "[UsersController] === REQUEST START ==="
      Rails.logger.info "[UsersController] Method: #{request.method}"
      Rails.logger.info "[UsersController] Path: #{request.path}"
      Rails.logger.info "[UsersController] IP: #{request.remote_ip}"
      Rails.logger.info "[UsersController] User-Agent: #{request.user_agent}"
      Rails.logger.info "[UsersController] Authorization header present: #{request.headers['Authorization'].present?}"
      Rails.logger.info "[UsersController] Authorization key: #{authorization_key&.first(10)}..." if authorization_key.present?
      Rails.logger.info "[UsersController] Provider credential found: #{provider_credential.present?}"
      
      if provider_credential.present?
        Rails.logger.info "[UsersController] Provider credential ID: #{provider_credential.id}"
        Rails.logger.info "[UsersController] Provider credential team_id: #{provider_credential.team_id}"
        Rails.logger.info "[UsersController] Provider credential team_name: #{provider_credential.team_name}"
      else
        Rails.logger.warn "[UsersController] No provider credential found for authorization key"
      end
      
      Rails.logger.info "[UsersController] === REQUEST DETAILS END ==="
    end
  end
end
