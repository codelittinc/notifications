# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProviderCredential, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:access_key) }
    it { should validate_presence_of(:team_id) }
    it { should validate_presence_of(:team_name) }
    it { should validate_presence_of(:application_key) }
  end
end
