# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate

  def index
    render json: Clients::Slack::User.new(provider_credential).list
  end
end
