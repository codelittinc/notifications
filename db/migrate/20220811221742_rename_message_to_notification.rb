# frozen_string_literal: true

class RenameMessageToNotification < ActiveRecord::Migration[6.1]
  def change
    rename_table :messages, :notifications
  end
end
