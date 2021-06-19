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

  describe '#index' do
    it 'list the reactions' do
      json = {
        channel: 'general',
        ts: '123'
      }

      expect_any_instance_of(Clients::Slack::Client)
        .to receive(:list_reactions)
        .with('#general', '123')

      request.headers['Authorization'] = authorization

      get :index, params: json
    end
  end

  describe '#create' do
    it 'creates a reaction' do
      json = {
        channel: 'general',
        reaction: ':white_check_mark:',
        ts: '123'
      }

      expect_any_instance_of(Clients::Slack::Client)
        .to receive(:add_reactions)
        .with('#general', ':white_check_mark:', '123')

      request.headers['Authorization'] = authorization

      post :create, params: json
    end
  end
end
