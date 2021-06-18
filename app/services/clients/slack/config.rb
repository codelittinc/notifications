# frozen_string_literal: true

module Clients
  module Slack
    class Config
      include Singleton
      attr_accessor :client_id, :client_secret
    end
  end
end
