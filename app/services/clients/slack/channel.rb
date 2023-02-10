# frozen_string_literal: true

require 'slack-ruby-client'

module Clients
  module Slack
    class Channel < Client
      def send!(channel, text, thread_ts = nil)
        channel = remove_hash(channel) if channel.upcase == channel

        begin
          client.chat_postMessage(
            channel:,
            text:,
            thread_ts:,
            link_names: true
          )
        rescue ::Slack::Web::Api::Errors::NotInChannel
          join!(channel)
          send!(channel, text, thread_ts)
        end
      end

      def update!(channel, text, timestamp)
        channel = remove_hash(channel) if channel.upcase == channel

        client.chat_update(
          channel:,
          text:,
          ts: timestamp,
          link_names: true
        )
      end

      def list
        channels = client.conversations_list(limit: 1000).channels
        channels.map { |channel| channel.slice(:id, :name).to_h }.sort_by { |hash| hash['name'] }
      end

      def join!(channel)
        client.conversations_join({
                                    channel:
                                  })
      end
    end
  end
end
