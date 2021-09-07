# frozen_string_literal: true

class ReactionsController < BaseMessageController
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
