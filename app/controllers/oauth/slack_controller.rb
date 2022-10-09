# frozen_string_literal: true

require 'uri'
require 'net/http'

module Oauth
  class SlackController < ApplicationController
    def create
      data = authenticate!

      access_key = data.with_indifferent_access[:access_token]
      team_id = data.with_indifferent_access[:team][:id]
      team_name = data.with_indifferent_access[:team][:name]

      authorization_bearer = save_credentials!(team_id, team_name, access_key)

      query = {
        application_key: authorization_bearer,
        team_name:,
        team_id:
      }

      encoded_data = URI.encode_www_form(query)

      redirect_to URI.parse("#{roadrunner_url}?#{encoded_data}").to_s
    end

    private

    def authenticate!
      code = params[:code]
      Clients::Slack::Oauth.new(code).authenticate!
    end

    def roadrunner_url
      @roadrunner_url ||= ENV.fetch('ROADRUNNER_URL', nil)
    end

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
