# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectMessagesController, type: :controller do
  let(:authorization) do
    ProviderCredential.create(access_key: '123', access_id: '123',
                              application_key: '12345').application_key
  end

  describe '#create' do
    it 'creates a message' do
      json = {
        username: 'vinicius',
        message: 'Hello World'
      }

      expect_any_instance_of(Clients::Slack::Client)
        .to receive(:create_direct_message!)
        .with('@vinicius', 'Hello World')

      request.headers['Authorization'] = authorization

      post :create, params: json
    end
  end
end
