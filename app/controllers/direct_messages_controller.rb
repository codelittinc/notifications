# frozen_string_literal: true

class DirectMessagesController < ApplicationController
  def create
    client = Clients::SlackClient.new
    render json: client.create_direct_message!(
      formatted_username,
      message
    )
  end

  def formatted_username
    "@#{params[:username]}"
  end
end
