# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReactionsController, type: :controller do
  let(:provider_credential) do
    ProviderCredential.create(
      access_key: '123',
      team_id: '123',
      team_name: 'codelitt',
      application_key: '12345'
    )
  end

  let(:authorization) do
    provider_credential.application_key
  end

  describe '#create' do
    it 'creates a reaction' do
      json = {
        channel: 'general',
        reaction: ':white_check_mark:',
        notification_id: '123'
      }

      expect_any_instance_of(Clients::Slack::Reaction)
        .to receive(:send!)
        .with('#general', ':white_check_mark:', '123').and_return({
                                                                    'ts' => '123'
                                                                  })

      request.headers['Authorization'] = authorization

      post :create, params: json
    end

    it 'does not try sending a reaction if message from target identifier does not exist' do
      notification_request = NotificationRequest.create(
        provider_credential:,
        target_name: '#general',
        target_type: 'channel',
        action: 'create',
        content: 'Hello World',
        target_identifier: '123'
      )

      json = {
        channel: 'general',
        reaction: ':white_check_mark:',
        notification_id: notification_request.id
      }

      request.headers['Authorization'] = authorization

      expect do
        post :create, params: json
      end.not_to raise_error

      post :create, params: json
    end
  end
end
