# frozen_string_literal: true

module Oauth
  class SlackController < ApplicationController
    def create
      code = params[:code]
      data = Clients::Slack::Oauth.new(code).authenticate!
      access_key = data.with_indifferent_access[:access_token]
      access_id = data.with_indifferent_access[:team][:id]

      authorization_bearer = save_credentials!(access_id, access_key)

      render json: {
        status: 200,
        notifications_access_id: authorization_bearer
      }
    end

    private

    def save_credentials!(access_id, access_key)
      credentials = ProviderCredential.find_or_initialize_by(
        access_id: access_id
      )
      credentials.access_key = access_key
      credentials.application_key = Base64.strict_encode64(access_key)
      credentials.save!
      credentials.application_key
    end
  end
end
