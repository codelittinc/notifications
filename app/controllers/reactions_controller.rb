# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :authenticate

  def create
    render json: client.add_reactions(
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
end
