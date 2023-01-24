# frozen_string_literal: true

module Api
  class ProviderCredentialsController < ApplicationController
    def show
      provider = ProviderCredential.find_by(team_id: params[:team_id])
      render json: { message: 'Not Found' }, status: :not_found unless provider
      render json: { id: provider.id } if provider
    end
  end
end
