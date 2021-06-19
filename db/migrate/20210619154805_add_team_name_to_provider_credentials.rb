# frozen_string_literal: true

class AddTeamNameToProviderCredentials < ActiveRecord::Migration[6.1]
  def change
    add_column :provider_credentials, :team_name, :string
  end
end
