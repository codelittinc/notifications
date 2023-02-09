# frozen_string_literal: true

# == Schema Information
#
# Table name: notification_requests
#
#  id                     :bigint           not null, primary key
#  action                 :string
#  content                :string
#  fulfilled              :boolean
#  json                   :string
#  target_identifier      :string
#  target_name            :string
#  target_type            :string
#  uniq                   :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider_credential_id :bigint           not null
#
require 'rails_helper'

RSpec.describe NotificationRequest, type: :model do
  describe 'validations' do
    it { should have_one(:notification) }

    it { should belong_to(:provider_credential) }

    it { should validate_length_of(:target_name).is_at_least(3) }
  end
end
