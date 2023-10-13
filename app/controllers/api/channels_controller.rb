# frozen_string_literal: true

module Api
  class ChannelsController < ApplicationController
    before_action :authenticate

    def index
      channels = Rails.cache.fetch(channel_cache_key, expires_in: 60.seconds) do
        Clients::Slack::Channel.new(provider_credential).list
      end

      render json: channels
    end

    private

    def channel_cache_key
      "slack_channels_#{provider_credential.id}"
    end
  end
end
