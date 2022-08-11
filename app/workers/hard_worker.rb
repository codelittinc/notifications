# frozen_string_literal: true

class HardWorker
  include Sidekiq::Worker

  def perform(notification_id)
    notification_request = NotificationRequest.find_by(id: notification_id)
    MessageSender.call(notification_request)
  end
end
