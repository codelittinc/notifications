# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :client

  def index
    render json: { status: 200 }
  end

  def authenticate
    credentials = ProviderCredential.find_by(application_key: authorization_key)

    if credentials
      @client = Clients::Slack::Client.new(credentials)
    else
      render status: :unauthorized
    end
  end

  def authorization_key
    request.headers['Authorization']&.gsub('Bearer ', '')
  end
end
