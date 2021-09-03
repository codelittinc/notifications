# frozen_string_literal: true

class RenameTargetToTargetName < ActiveRecord::Migration[6.1]
  def change
    rename_column :notification_requests, :target, :target_name
  end
end
