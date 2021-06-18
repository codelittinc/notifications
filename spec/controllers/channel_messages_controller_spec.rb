# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChannelMessagesController, type: :controller do
  let(:authorization) do
    ProviderCredential.create(access_key: '123', access_id: '123',
                              application_key: '12345').application_key
  end

  describe '#create' do
    it 'creates a message' do
      json = { channel: 'general', message: 'Hello World', ts: '123' }

      expect_any_instance_of(Clients::Slack::Client)
        .to receive(:create_channel_message!)
        .with('#general', 'Hello World', '123', true)

      request.headers['Authorization'] = authorization

      post :create, params: json
    end
  end

  describe '#update' do
    it 'updates a message' do
      json = {
        id: '123456',
        channel: 'general',
        message: 'I am updating',
        ts: '123'
      }

      expect_any_instance_of(
        Clients::Slack::Client
      ).to receive(:update_message!)
        .with('#general', 'I am updating', '123', true)

      request.headers['Authorization'] = authorization

      post :update, params: json
    end
  end
end
