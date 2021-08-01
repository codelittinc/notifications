# frozen_string_literal: true

class AddTargetIdentifierToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :target_identifier, :string
  end
end
