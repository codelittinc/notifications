# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :client

  def index
    render json: {
      status: 200,
      slack_url: Clients::Slack::Oauth.auth_url
    }
  end

  private

  def authenticate
    Rails.logger.info "[ApplicationController#authenticate] Starting authentication"
    Rails.logger.info "[ApplicationController#authenticate] Authorization header: #{request.headers['Authorization']&.first(20)}..." if request.headers['Authorization'].present?
    Rails.logger.info "[ApplicationController#authenticate] Authorization key: #{authorization_key&.first(10)}..." if authorization_key.present?
    
    if provider_credential
      Rails.logger.info "[ApplicationController#authenticate] Provider credential found: ID=#{provider_credential.id}"
      @client = Clients::Slack::Client.new(provider_credential)
      Rails.logger.info "[ApplicationController#authenticate] Slack client initialized successfully"
    else
      Rails.logger.warn "[ApplicationController#authenticate] No provider credential found - returning unauthorized"
      Rails.logger.warn "[ApplicationController#authenticate] Available provider credentials: #{ProviderCredential.count}"
      Rails.logger.warn "[ApplicationController#authenticate] Authorization key provided: #{authorization_key.present?}"
      render json: { error: 'Unauthorized', message: 'Invalid or missing authorization key' }, status: :unauthorized
    end
  rescue => e
    Rails.logger.error "[ApplicationController#authenticate] Error during authentication: #{e.class}: #{e.message}"
    Rails.logger.error "[ApplicationController#authenticate] Backtrace: #{e.backtrace.first(5).join('\n')}"
    render json: { error: 'Authentication error', message: e.message }, status: :internal_server_error
  end

  def provider_credential
    Rails.logger.debug "[ApplicationController#provider_credential] Looking up provider credential with key: #{authorization_key&.first(10)}..."
    @provider_credential ||= ProviderCredential.find_by(application_key: authorization_key)
    Rails.logger.debug "[ApplicationController#provider_credential] Found: #{@provider_credential.present?}"
    @provider_credential
  end

  def authorization_key
    @authorization_key ||= request.headers['Authorization']&.gsub('Bearer ', '')
  end
end
