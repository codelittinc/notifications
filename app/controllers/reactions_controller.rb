# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :authenticate
  before_action :set_notification_request!

  def create
    render json: MessageSender.call(@request)
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
