# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :set_client, only: %i[index create]

  def index
    @client.list_reactions(formatted_channel, ts)
  end

  def create
    @client.add_reactions(
      formatted_channel,
      reaction,
      ts
    )
  end

  private

  def reaction
    params[:reaction]
  end

  def formatted_channel
    "\##{params[:channel]}"
  end

  def ts
    params[:ts]
  end

  def set_client
    @client = Clients::SlackClient.new
  end
end
