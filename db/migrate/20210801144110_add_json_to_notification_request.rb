# frozen_string_literal: true

class AddJsonToNotificationRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :notification_requests, :json, :string
  end
end
