# frozen_string_literal: true

# == Schema Information
#
# Table name: provider_credentials
#
#  id              :bigint           not null, primary key
#  access_key      :string
#  team_id         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  application_key :string
#  team_name       :string
#
class ProviderCredential < ApplicationRecord
  has_many :messages, dependent: :destroy

  validates :access_key, presence: true
  validates :team_id, presence: true
  validates :team_name, presence: true
  validates :application_key, presence: true
end
