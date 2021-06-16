# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReactionsController, type: :controller do
  describe '#index' do
    it 'list the reactions' do
      json = {
        channel: 'general',
        ts: '123'
      }

      expect_any_instance_of(Clients::SlackClient)
        .to receive(:list_reactions)
        .with('#general', '123')

      get :index, params: json
    end
  end

  describe '#create' do
    it 'creates a reaction' do
      json = {
        channel: 'general',
        reaction: ':white_check_mark:',
        ts: '123'
      }

      expect_any_instance_of(Clients::SlackClient)
        .to receive(:add_reactions)
        .with('#general', ':white_check_mark:', '123')

      post :create, params: json
    end
  end
end
