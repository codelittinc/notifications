# frozen_string_literal: true

class MessageCreator < ApplicationService
  def initialize(provider, action, target_type, message, channel)
    super()
    @action = action
    @target_type = target_type
    @text = message
    @channel = channel
    @provider = provider
  end

  def call
    Message.create(
      text: @text,
      target_type: @target_type,
      action: @action,
      target: @channel,
      provider_credential: @provider
    )
  end
end
