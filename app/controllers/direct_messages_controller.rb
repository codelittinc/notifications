# frozen_string_literal: true

class DirectMessagesController < BaseMessageController
  private

  def target_type
    'direct'
  end

  def target
    "@#{params[:username]}"
  end

  def content
    params[:message]
  end
end
