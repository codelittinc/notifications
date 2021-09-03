# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :authenticate

  def create
    render json: MessageSender.call(notification_request)
  end

  private

  def content
    params[:reaction]
  end

  def target_type
    'reaction'
  end

  def target
    "\##{params[:channel]}"
  end
end
