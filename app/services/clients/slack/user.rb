# frozen_string_literal: true

require 'slack-ruby-client'

module Clients
  module Slack
    class User < Client
      def list
        response = client.users_list
        members = response['members']
        members.map do |member|
          member['name']
        end
      end
    end
  end
end
