# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectMessagesController, type: :controller do
  describe '#create' do
    it 'creates a message' do
      json = {
        username: 'vinicius',
        message: 'Hello World'
      }

      expect_any_instance_of(Clients::SlackClient)
        .to receive(:create_direct_message!)
        .with('@vinicius', 'Hello World')

      post :create, params: json
    end
  end
end
