# frozen_string_literal: true

class RenameAccessIdToTeamIdToProviderCredentials < ActiveRecord::Migration[6.1]
  def change
    rename_column :provider_credentials, :access_id, :team_id
  end
end
