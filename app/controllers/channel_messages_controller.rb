# frozen_string_literal: true

class ChannelMessagesController < ApplicationController
  before_action :authenticate

  def create
    render json: MessageSender.call(notification_request)
  end

  def update
    render json: MessageSender.call(notification_request)
  end

  private

  def target_type
    'channel'
  end

  def target
    "\##{params[:channel]}"
  end

  def content
    params[:message]
  end
end
