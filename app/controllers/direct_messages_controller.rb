# frozen_string_literal: true

class DirectMessagesController < ApplicationController
  def create
    MessageCreator.new('create', 'direct', message, formatted_username).create!

    render json: client.create_direct_message!(formatted_username, message)
  end

  private

  def formatted_username
    "@#{params[:username]}"
  end

  def message
    params[:message]
  end
end
