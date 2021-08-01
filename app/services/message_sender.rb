# frozen_string_literal: true

class MessageSender < ApplicationService
  delegate :provider_credential, :action, :target_type, :content, :target, :target_identifier, :uniq,
           to: :notification_request
  attr_reader :notification_request

  def initialize(notification_request)
    super()
    @notification_request = notification_request
  end

  def call
    return unless create_message!

    class_const = Object.const_get("Clients::Slack::#{target_type.capitalize}")
    client = class_const.new(provider_credential)

    case action
    when 'create'
      response = client.send!(target, content, target_identifier)
    when 'update'
      response = client.update!(target, content, target_identifier)
    end

    @notification_request.update(fulfilled: true)
    response
  end

  private

  def create_message!
    MessageCreator.call(
      provider_credential,
      action,
      target_type,
      content,
      target,
      uniq
    )
  end
end
