# frozen_string_literal: true

class CreateNotificationRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :notification_requests do |t|
      t.boolean :fulfilled
      t.boolean :uniq
      t.string :target
      t.string :target_type
      t.string :content
      t.string :action
      t.string :target_identifier
      t.references :provider_credential, null: false, foreign_key: true
      t.timestamps
    end
  end
end
