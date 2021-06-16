# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    client = Clients::SlackClient.new
    client.list_users
  end
end
