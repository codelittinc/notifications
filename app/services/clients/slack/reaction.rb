# frozen_string_literal: true

require 'slack-ruby-client'

module Clients
  module Slack
    class Reaction < Client
      def send!(formatted_channel, reaction, timestamp)
        # @TODO: remove this cleaning from this method
        return unless timestamp

        clean_reactions!(formatted_channel, timestamp)

        client.reactions_add(
          channel: formatted_channel,
          name: reaction,
          timestamp:
        )
      end

      private

      def list_reactions(formatted_channel, timestamp)
        response = client.reactions_get(
          channel: formatted_channel,
          timestamp:
        )
        response['message']['reactions']
      end

      def clean_reactions!(formatted_channel, timestamp)
        reactions = list_reactions(formatted_channel, timestamp)
        reactions&.each do |reaction|
          remove_reaction!(reaction['name'], formatted_channel, timestamp)
        end
      end

      def remove_reaction!(name, formatted_channel, timestamp)
        client.reactions_remove(
          name:,
          timestamp:,
          channel: formatted_channel
        )
      end
    end
  end
end
