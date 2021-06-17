# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    client = Clients::SlackClient.new
    render json: client.list_users
  end
end
