# frozen_string_literal: true

class AddApplicationKeyToProviderCredentials < ActiveRecord::Migration[6.1]
  def change
    add_column :provider_credentials, :application_key, :string
  end
end
