# frozen_string_literal: true

class DirectMessagesController < ApplicationController
  before_action :authenticate

  def create
    render json: MessageSender.call(notification_request)
  end

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
