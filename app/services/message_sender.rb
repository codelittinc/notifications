# frozen_string_literal: true

class MessageSender < ApplicationService
  delegate :provider_credential, :action, :target_type, :content, :target_name, :target_identifier, :uniq,
           to: :notification_request
  attr_reader :notification_request

  def initialize(notification_request)
    super()
    @notification_request = notification_request
  end

  def call
    message = create_message!
    return unless message

    response = execute_message!
    message.update(target_identifier: response['ts'])

    @notification_request.update(fulfilled: true)
    response
  end

  private

  def create_message!
    target_data = { name: target_name, type: target_type }

    MessageCreator.call(
      action,
      content,
      notification_request,
      provider_credential,
      target_data,
      uniq
    )
  end

  def execute_message!
    class_const = Object.const_get("Clients::Slack::#{target_type.capitalize}")
    client = class_const.new(provider_credential)

    case action
    when 'create'
      client.send!(target_name, content, target_identifier)
    when 'update'
      client.update!(target_name, content, target_identifier)
    end
  end
end
