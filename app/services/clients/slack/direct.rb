# frozen_string_literal: true

require 'slack-ruby-client'

module Clients
  module Slack
    class Direct < Client
      def send!(channel, text, thread_ts = nil)
        client.chat_postMessage(
          channel:,
          text:,
          thread_ts:
        )
      end
    end
  end
end
