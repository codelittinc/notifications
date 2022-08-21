# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate

    def index
      render json: Clients::Slack::User.new(provider_credential).list
    end
  end
end
