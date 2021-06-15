# frozen_string_literal: true

class ApplicationController < ActionController::API
  def message
    params[:message]
  end
end
