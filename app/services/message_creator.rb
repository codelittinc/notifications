# frozen_string_literal: true

class MessageCreator < ApplicationService
  def initialize(provider, action, target_type, message, target, uniq)
    super()
    @action = action
    @target_type = target_type
    @text = message
    @target = target
    @provider = provider
    @uniq = uniq
  end

  def call
    return nil if @uniq && Message.exists?(text: @text, target: @target, provider_credential: @provider)

    Message.create(
      text: @text,
      target_type: @target_type,
      action: @action,
      target: @target,
      provider_credential: @provider
    )
  end
end
