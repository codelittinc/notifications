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
require 'rails_helper'

RSpec.describe ProviderCredential, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:access_key) }
    it { should validate_presence_of(:team_id) }
    it { should validate_presence_of(:team_name) }
    it { should validate_presence_of(:application_key) }
  end
end
