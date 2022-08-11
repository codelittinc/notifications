# frozen_string_literal: true

require 'slack-ruby-client'

module Clients
  module Slack
    class Channel < Client
      def send!(channel, text, thread_ts = nil)
        return if channel == '#'

        client.chat_postMessage(
          channel:,
          text:,
          thread_ts:,
          link_names: true
        )
      end

      def update!(channel, text, timestamp)
        client.chat_update(
          channel:,
          text:,
          ts: timestamp,
          link_names: true
        )
      end
    end
  end
end
