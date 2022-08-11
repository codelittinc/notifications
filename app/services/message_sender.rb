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
    error = nil
    ActiveRecord::Base.transaction do
      message = create_message!

      response = execute_message!
      message.update(target_identifier: response['ts'])

      @notification_request.update(fulfilled: true)
    rescue StandardError => e
      error = e
      raise ActiveRecord::Rollback
    end
    raise(error) if error.present?
  end

  private

  def create_message!
    target = { name: target_name, type: target_type }

    MessageCreator.call(
      action,
      content,
      notification_request,
      provider_credential,
      target,
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
