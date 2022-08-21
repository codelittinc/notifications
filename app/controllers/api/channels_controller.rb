# frozen_string_literal: true

module Api
  class ChannelsController < ApplicationController
    before_action :authenticate

    def index
      render json: Clients::Slack::Channel.new(provider_credential).list
    end
  end
end
