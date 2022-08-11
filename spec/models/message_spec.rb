# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id                      :bigint           not null, primary key
#  text                    :string
#  target_type             :string
#  action                  :string
#  target                  :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  provider_credential_id  :bigint
#  target_identifier       :string
#  notification_request_id :bigint
#
require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should belong_to(:provider_credential) }
    it { should belong_to(:notification_request).optional }

    it { should validate_presence_of(:text) }
    it { should validate_presence_of(:target_type) }
    it {
      should validate_inclusion_of(:target_type).in_array(%w[direct channel reaction])
    }
    it { should validate_presence_of(:action) }
    it { should validate_inclusion_of(:action).in_array(%w[create update]) }
    it { should validate_presence_of(:target) }
  end
end
