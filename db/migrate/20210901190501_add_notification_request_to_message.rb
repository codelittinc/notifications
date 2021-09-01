# frozen_string_literal: true

class AddNotificationRequestToMessage < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :notification_request, null: true, foreign_key: true
  end
end
