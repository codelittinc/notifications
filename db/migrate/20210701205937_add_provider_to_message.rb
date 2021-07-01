# frozen_string_literal: true

class AddProviderToMessage < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :provider_credential, foreign_key: true
  end
end
