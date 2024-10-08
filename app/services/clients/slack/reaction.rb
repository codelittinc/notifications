# frozen_string_literal: true

require 'slack-ruby-client'

module Clients
  module Slack
    class Reaction < Client
      def send!(channel, reaction, timestamp)
        return unless timestamp

        channel = remove_hash(channel) if channel.upcase == channel

        begin
          clean_reactions!(channel, timestamp)
          client.reactions_add(
            channel:,
            name: reaction,
            timestamp:
          )
        rescue ::Slack::Web::Api::Errors::NotInChannel
          join!(channel)
          send!(channel, reaction, timestamp)
        end
      end

      private

      def list_reactions(channel, timestamp)
        response = client.reactions_get(channel:,
                                        timestamp:)
        response['message']['reactions']
      end

      def clean_reactions!(channel, timestamp)
        reactions = list_reactions(channel, timestamp)
        reactions&.each do |reaction|
          remove_reaction!(reaction['name'], channel, timestamp)
        end
      end

      def remove_reaction!(name, channel, timestamp)
        client.reactions_remove(
          name:,
          timestamp:,
          channel:
        )
      end

      def remove_hash(channel)
        channel.gsub('#', '')
      end
    end
  end
end
