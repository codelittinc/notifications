# frozen_string_literal: true

class DirectMessagesController < ApplicationController
  before_action :authenticate

  def create
    MessageCreator.new(provider_credential, 'create', 'direct', message,
                       formatted_username).create!

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
