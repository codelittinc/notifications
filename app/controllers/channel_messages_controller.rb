# frozen_string_literal: true

class ChannelMessagesController < ApplicationController
  before_action :set_client, only: %i[create update]

  def create
    render json: @client.create_channel_message!(
      formatted_channel,
      message,
      timestamp,
      true
    )
  end

  def update
    render json: @client.update_message!(
      formatted_channel,
      message,
      timestamp,
      true
    )
  end

  private

  def formatted_channel
    "\##{params[:channel]}"
  end

  def timestamp
    params[:id] || params[:ts]
  end

  def set_client
    @client = Clients::SlackClient.new
  end
end
