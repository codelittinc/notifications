# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :client

  def index
    render json: { status: 200 }
  end

  private

  def authenticate
    if provider_credential
      @client = Clients::Slack::Client.new(provider_credential)
    else
      render status: :unauthorized
    end
  end

  def provider_credential
    @provider_credential ||= ProviderCredential.find_by(application_key: authorization_key)
  end

  def authorization_key
    request.headers['Authorization']&.gsub('Bearer ', '')
  end
end
