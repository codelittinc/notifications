# frozen_string_literal: true

class ChannelMessagesController < ApplicationController
  before_action :authenticate

  def create
    MessageCreator.call(provider_credential, 'create', 'channel', message,
                        formatted_channel)

    render json: client.create_channel_message!(formatted_channel, message, timestamp)
  end

  def update
    MessageCreator.call(provider_credential, 'update', 'channel', message,
                        formatted_channel)

    render json: client.update_message!(formatted_channel, message, timestamp)
  end

  private

  def formatted_channel
    "\##{params[:channel]}"
  end

  def timestamp
    params[:ts]
  end

  def message
    params[:message]
  end
end
