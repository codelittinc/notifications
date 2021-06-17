# frozen_string_literal: true

class MessageCreator
  def initialize(action, target_type, message, channel)
    @action = action
    @target_type = target_type
    @text = message
    @channel = channel
  end

  def create!
    Message.create(
      text: @text,
      target_type: @target_type,
      action: @action,
      target: @channel
    )
  end
end
