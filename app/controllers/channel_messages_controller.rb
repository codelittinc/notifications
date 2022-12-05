# frozen_string_literal: true

class ChannelMessagesController < BaseMessageController
  private

  def target_type
    'channel'
  end

  def target
    "##{params[:channel]}"
  end

  def content
    params[:message]
  end
end
