# frozen_string_literal: true

class BaseMessageController < ApplicationController
  before_action :authenticate

  after_action :schedule_worker, if: proc { Rails.env.production? }
  after_action :execute_notification, unless: proc { Rails.env.production? }

  def create
    render json: { notification_id: notification_request.id.to_s }
  end

  def update
    render json: { notification_id: notification_request.id.to_s }
  end

  private

  def create_notification_request!
    notification = NotificationRequest.new(
      provider_credential: provider_credential,
      target_name: target,
      target_type: target_type,
      action: params[:action],
      content: content,
      target_identifier: target_identifier,
      uniq: params[:uniq],
      json: params
    )
    notification.save
    notification
  end

  def notification_request
    @notification_request ||= create_notification_request!
  end

  def target_identifier
    notification_id = params[:notification_id]
    return nil unless notification_id

    notification_target = NotificationRequest.find_by(id: notification_id)
    return notification_target.message.target_identifier if notification_target.present?

    notification_id
  end

  def schedule_worker
    HardWorker.perform_async(notification_request.id)
  end

  def execute_notification
    MessageSender.call(notification_request)
  end
end
