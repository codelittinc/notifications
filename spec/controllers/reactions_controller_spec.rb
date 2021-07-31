# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReactionsController, type: :controller do
  let(:authorization) do
    ProviderCredential.create(
      access_key: '123',
      team_id: '123',
      team_name: 'codelitt',
      application_key: '12345'
    ).application_key
  end

  describe '#create' do
    it 'creates a reaction' do
      json = {
        channel: 'general',
        reaction: ':white_check_mark:',
        ts: '123'
      }

      expect_any_instance_of(Clients::Slack::Reaction)
        .to receive(:send!)
        .with('#general', ':white_check_mark:', '123')

      request.headers['Authorization'] = authorization

      post :create, params: json
    end
  end
end
