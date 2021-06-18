# frozen_string_literal: true

class ApplicationController < ActionController::API
  def index
    render json: { status: 200 }
  end

  def authorization_key
    request.headers['Authorization']&.gsub('Bearer ', '')
  end

  def client
    return unless authorization_key

    provider_credentials = ProviderCredential.find_by(
      application_key: authorization_key
    )
    @client = Clients::Slack::Client.new(provider_credentials)
  end
end
