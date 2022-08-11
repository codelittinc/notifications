# frozen_string_literal: true

class MessageCreator < ApplicationService
  def initialize(action, message, notification_request, provider, target, uniq)
    super()
    @action = action
    @notification_request = notification_request
    @provider = provider
    @target_name = target[:name]
    @target_type = target[:type]
    @text = message
    @uniq = uniq
  end

  def call
    raise('It is trying to recreate a message that should be unique.') if repeating_message_that_should_be_unique?

    Notification.create!(
      action: @action,
      notification_request: @notification_request,
      provider_credential: @provider,
      target: @target_name,
      target_type: @target_type,
      text: @text
    )
  end

  def repeating_message_that_should_be_unique?
    @uniq && Notification.exists?(text: @text,
                                  target: @target_name, provider_credential: @provider)
  end
end
