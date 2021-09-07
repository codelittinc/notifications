# frozen_string_literal: true

class HardWorker
  include Sidekiq::Worker

  def perform(notification_id)
    notification_request = NotificationRequest.find_by(id: notification_id)
    begin
      MessageSender.call(notification_request)
    rescue StandardError => e
      message = [e.to_s, e.backtrace].flatten.join("\n")
      Rails.logger.error "ERROR: #{message}"
      raise e
    end
  end
end
