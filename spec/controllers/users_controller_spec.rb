# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#index' do
    it 'list the users' do
      expect_any_instance_of(Clients::SlackClient)
        .to receive(:list_users)

      get :index
    end
  end
end
