# frozen_string_literal: true

class ChannelMessagesController < ApplicationController
  before_action :set_client, only: %i[create update]

  def create
    @client.create_message!(formatted_channel, message, timestamp, true)
  end

  def update
    @client.update_message!(formatted_channel, message, id, true)
  end

  private

  def formatted_channel
    "\##{params[:channel]}"
  end

  def timestamp
    params[:timestamp]
  end

  def id
    params[:id]
  end

  def set_client
    @client = Clients::SlackClient.new
  end
end
