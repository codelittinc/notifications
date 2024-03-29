# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let(:authorization) do
    ProviderCredential.create(
      access_key: '123',
      team_id: '123',
      team_name: 'codelitt',
      application_key: '12345'
    ).application_key
  end

  describe '#index' do
    it 'list the users' do
      expect_any_instance_of(Clients::Slack::User)
        .to receive(:list)

      request.headers['Authorization'] = authorization

      get :index
    end
  end
end
