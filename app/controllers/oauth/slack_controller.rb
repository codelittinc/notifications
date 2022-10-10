# frozen_string_literal: true

require 'uri'
require 'net/http'

module Oauth
  class SlackController < ApplicationController
    def create
      data = authenticate!

      credentials = save_credentials!(data)

      response = Request.post(organizations_url, '', organizations_body(credentials))
      organizations_id = JSON.parse(response.body)['id']

      organizations_path = URI.parse("#{roadrunner_url}/organizations/#{organizations_id}").to_s

      redirect_to organizations_path
    end

    private

    def organizations_body(credentials)
      {
        notifications_key: credentials.application_key,
        name: credentials.team_name,
        notifications_id: credentials.id
      }
    end

    def authenticate!
      code = params[:code]
      Clients::Slack::Oauth.new(code).authenticate!
    end

    def organizations_url
      "#{roadrunner_url}/organizations"
    end

    def roadrunner_url
      @roadrunner_url ||= ENV.fetch('ROADRUNNER_URL', nil)
    end

    def save_credentials!(data)
      team_id = data.with_indifferent_access[:team][:id]
      credentials = ProviderCredential.find_or_initialize_by(team_id:)
      credentials.team_name = data.with_indifferent_access[:team][:name]
      credentials.access_key = data.with_indifferent_access[:access_token]
      credentials.application_key = Base64.strict_encode64(credentials.access_key)
      credentials.save!
      credentials
    end
  end
end
