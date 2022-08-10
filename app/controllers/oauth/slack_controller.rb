# frozen_string_literal: true

module Oauth
  class SlackController < ApplicationController
    def create
      code = params[:code]
      data = Clients::Slack::Oauth.new(code).authenticate!
      access_key = data.with_indifferent_access[:access_token]
      team_id = data.with_indifferent_access[:team][:id]
      team_name = data.with_indifferent_access[:team][:name]

      authorization_bearer = save_credentials!(team_id, team_name, access_key)

      render json: {
        status: 200,
        application_key: authorization_bearer
      }
    end

    private

    def save_credentials!(team_id, team_name, access_key)
      credentials = ProviderCredential.find_or_initialize_by(
        team_id:
      )
      credentials.team_name = team_name
      credentials.access_key = access_key
      credentials.application_key = Base64.strict_encode64(access_key)
      credentials.save!
      credentials.application_key
    end
  end
end
