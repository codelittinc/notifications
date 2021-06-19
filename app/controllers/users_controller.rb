# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate

  def index
    render json: client.list_users
  end
end
