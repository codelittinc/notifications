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
    if provider_credential
      @client = Clients::Slack::Client.new(provider_credential)
    else
      render json: { error: 'Unauthorized', message: 'Invalid or missing authorization key' }, status: :unauthorized
    end
  rescue StandardError => e
    Rails.logger.error "Authentication error: #{e.class}: #{e.message}"
    render json: { error: 'Authentication error', message: e.message }, status: :internal_server_error
  end

  def provider_credential
    @provider_credential ||= ProviderCredential.find_by(application_key: authorization_key)
  end

  def authorization_key
    @authorization_key ||= request.headers['Authorization']&.gsub('Bearer ', '')
  end
end
