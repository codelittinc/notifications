# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:text) }
    it { should validate_presence_of(:target_type) }
    it {
      should validate_inclusion_of(:target_type).in_array(%w[direct channel])
    }
    it { should validate_presence_of(:action) }
    it { should validate_inclusion_of(:action).in_array(%w[create update]) }
    it { should validate_presence_of(:target) }
  end
end
