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
    return nil if @uniq && Message.exists?(text: @text, target: @target_name, provider_credential: @provider)

    Message.create(
      action: @action,
      notification_request: @notification_request,
      provider_credential: @provider,
      target: @target_name,
      target_type: @target_type,
      text: @text
    )
  end
end
