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

    def create_channel_message!(channel, text, thread_ts, link_names)
      client.chat_postMessage(
        channel: channel,
        text: text,
        thread_ts: thread_ts,
        link_names: link_names
      )
    end

    def create_direct_message!(channel, text)
      client.chat_postMessage(
        channel: channel,
        text: text
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

    def list_reactions(formatted_channel, timestamp)
      response = client.reactions_get(
        channel: formatted_channel,
        timestamp: timestamp
      )
      response['message']['reactions']
    end

    def clean_reactions!(formatted_channel, timestamp)
      reactions = list_reactions(formatted_channel, timestamp)
      reactions&.each do |reaction|
        remove_reaction!(reaction['name'])
      end
    end

    def remove_reaction!(name)
      client.reactions_remove(
        name: name,
        timestamp: ts,
        channel: formatted_channel
      )
    end

    def add_reactions(formatted_channel, reaction, timestamp)
      # @TODO: remove this cleaning from this method
      client.clean_reactions!(formatted_channel, ts)

      client.reactions_add(
        channel: formatted_channel,
        name: reaction,
        timestamp: timestamp
      )
    end

    private

    def client
      return @client if @client

      @client = Slack::Web::Client.new
    end
  end
end
