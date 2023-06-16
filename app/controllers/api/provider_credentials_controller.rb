# frozen_string_literal: true

module Api
  class ProviderCredentialsController < ApplicationController
    def show
      provider = ProviderCredential.find_by(team_id: params[:team_id])
      render json: { message: 'Not Found' }, status: :not_found unless provider
      render json: { id: provider.id } if provider
    end

    def create
      credentials = ProviderCredential.find_by(team_id: params[:team_id])
      if credentials.nil?
        application_key = Base64.strict_encode64(params[:access_token])
        credentials = ProviderCredential.create(
          access_key: params[:access_token],
          team_id: params[:team_id],
          team_name: params[:team_name],
          application_key:
        )
      end

      render json: { credentials: } if credentials
    end
  end
end
