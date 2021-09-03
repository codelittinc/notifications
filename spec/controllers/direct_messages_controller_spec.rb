# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectMessagesController, type: :controller do
  let(:authorization) do
    ProviderCredential.create(
      access_key: '123',
      team_id: '123',
      team_name: 'codelitt',
      application_key: '12345'
    ).application_key
  end

  describe '#create' do
    it 'creates a message' do
      json = {
        username: 'vinicius',
        message: 'Hello World'
      }

      expect_any_instance_of(Clients::Slack::Direct)
        .to receive(:send!)
        .with('@vinicius', 'Hello World', nil).and_return({
                                                            'ts' => '123'
                                                          })

      request.headers['Authorization'] = authorization

      post :create, params: json
    end

    it 'creates a message with a notification request' do
      json = {
        username: 'vinicius',
        message: 'Hello World'
      }

      expect_any_instance_of(Clients::Slack::Direct)
        .to receive(:send!)
        .with('@vinicius', 'Hello World', nil).and_return({
                                                            'ts' => '123'
                                                          })

      request.headers['Authorization'] = authorization

      post :create, params: json

      expect(Message.last.notification_request).to eql(NotificationRequest.last)
    end
  end
end
