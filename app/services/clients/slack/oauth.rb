# frozen_string_literal: true

require 'uri'
require 'net/http'

module Clients
  module Slack
    class Oauth
      SLACK_AUTHENTICATE_URL = 'https://slack.com/api/oauth.v2.access'

      def initialize(code)
        @code = code
      end

      def authenticate!
        data =  {
          code: @code,
          client_id: Clients::Slack::Config.instance.client_id,
          client_secret: Clients::Slack::Config.instance.client_secret
        }

        post(data)
      end

      private

      def post(body)
        encoded_data = URI.encode_www_form(body)

        uri = URI.parse("#{SLACK_AUTHENTICATE_URL}?#{encoded_data}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Get.new(uri.request_uri)
        JSON.parse(http.request(req).body)
      end
    end
  end
end
