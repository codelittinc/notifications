# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.string :text
      t.string :target_type
      t.string :action
      t.string :target

      t.timestamps
    end
  end
end
