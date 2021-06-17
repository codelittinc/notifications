# frozen_string_literal: true

class ProviderCredential < ApplicationRecord
  validates :access_key, presence: true
  validates :access_id, presence: true
end
