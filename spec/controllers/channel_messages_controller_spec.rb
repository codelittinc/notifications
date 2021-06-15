# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChannelMessagesController, type: :controller do
  describe '#create' do
    it 'creates a message' do
      json = {
        channel: 'general',
        message: 'Hello World',
        ts: '123'
      }

      expect_any_instance_of(Clients::SlackClient)
        .to receive(:create_channel_message!)
        .with('#general', 'Hello World', '123', true)

      post :create, params: json
    end
  end

  describe '#update' do
    it 'updates a message' do
      json = {
        channel: 'general',
        message: 'I am updating',
        id: '123'
      }

      expect_any_instance_of(Clients::SlackClient).to receive(:update_message!)
        .with('#general', 'I am updating', '123', true)

      patch :update, params: json
    end
  end
end
