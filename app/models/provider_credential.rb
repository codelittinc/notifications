# frozen_string_literal: true

class ProviderCredential < ApplicationRecord
  validates :access_key, presence: true
  validates :team_id, presence: true
  validates :team_name, presence: true
  validates :application_key, presence: true
end
