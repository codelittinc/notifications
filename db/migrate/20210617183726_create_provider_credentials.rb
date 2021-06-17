# frozen_string_literal: true

class CreateProviderCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :provider_credentials do |t|
      t.string :access_key
      t.string :access_id

      t.timestamps
    end
  end
end
