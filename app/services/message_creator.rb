# frozen_string_literal: true

class MessageCreator
  def initialize(provider, action, target_type, message, channel)
    @action = action
    @target_type = target_type
    @text = message
    @channel = channel
    @provider = provider
  end

  def create!
    Message.create(
      text: @text,
      target_type: @target_type,
      action: @action,
      target: @channel,
      provider_credential: @provider
    )
  end
end
