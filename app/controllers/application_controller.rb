# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :client

  def index
    render json: { status: 200 }
  end

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

  def create_notification_request!
    notification = NotificationRequest.new(
      provider_credential: provider_credential,
      target_name: target,
      target_type: target_type,
      action: params[:action],
      content: content,
      target_identifier: params[:ts],
      uniq: params[:uniq],
      json: params
    )
    notification.save
    notification
  end

  def notification_request
    @notification_request ||= create_notification_request!
  end
end
