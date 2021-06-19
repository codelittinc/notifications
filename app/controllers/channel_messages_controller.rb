# frozen_string_literal: true

class ChannelMessagesController < ApplicationController
  before_action :authenticate

  def create
    MessageCreator.new('create', 'channel', message, formatted_channel).create!

    render json: client.create_channel_message!(formatted_channel, message,
                                                timestamp, true)
  end

  def update
    MessageCreator.new('update', 'channel', message, formatted_channel).create!

    render json: client.update_message!(formatted_channel, message, timestamp,
                                        true)
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
