# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationRequest, type: :model do
  describe 'validations' do
    it { should have_one(:message) }

    it { should belong_to(:provider_credential) }
  end
end
