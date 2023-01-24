# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ProviderCredentialsController, type: :controller do
  describe '#show' do
    it 'get the credential provider id by the team id param' do
      provider_credential = ProviderCredential.create(
        access_key: '123',
        team_id: '123456',
        team_name: 'codelitt',
        application_key: '12345'
      )
      params_json = {
        team_id: provider_credential.team_id
      }

      response = get :show, params: params_json

      expect(response.body).to eql({ id: provider_credential.id }.to_json)
      expect(response.status).to eq(200)
    end

    it 'returns a 404 error in case the provider does not exist' do
      params_json = {
        team_id: '0'
      }

      response = get :show, params: params_json

      expect(response.body).to eql({ message: 'Not Found' }.to_json)
      expect(response.status).to eq(404)
    end
  end
end
