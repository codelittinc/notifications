# frozen_string_literal: true

require 'slack-ruby-client'

module Clients
  class SlackClient
    def initialize
      # rubocop:disable Rails/EnvironmentVariableAccess
      Slack.configure do |config|
        config.token = ENV['SLACK_API_KEY']
      end
      # rubocop:enable Rails/EnvironmentVariableAccess
    end

    def create_message!(channel, text, thread_ts, link_names)
      client.chat_postMessage(
        channel: channel,
        text: text,
        thread_ts: thread_ts,
        link_names: link_names
      )
    end

    def update_message!(channel, text, timestamp, link_names)
      client.chat_update(
        channel: channel,
        text: text,
        timestamp: timestamp,
        link_names: link_names
      )
    end

    private

    def client
      return @client if @client

      @client = Slack::Web::Client.new
    end
  end
end
