# frozen_string_literal: true

require 'slack-ruby-client'

module Clients
  module Slack
    class Client
      def initialize(provider_credential)
        ::Slack.configure do |config|
          config.token = provider_credential.access_key
        end
      end

      def client
        return @client if @client

        @client = ::Slack::Web::Client.new
      end
    end

    def remove_hash(channel)
      channel.gsub('#', '')
    end
  end
end
