# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChannelMessagesController, type: :controller do
  let(:provider) do
    ProviderCredential.create(
      access_key: '123',
      team_id: '123',
      team_name: 'codelitt',
      application_key: '12345'
    )
  end

  let(:authorization) do
    provider.application_key
  end

  describe '#create' do
    it 'sends a message' do
      json = { channel: 'general', message: 'Hello World', ts: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      post :create, params: json
    end

    it 'returns the slack response' do
      json = { channel: 'general', message: 'Hello World', ts: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      post :create, params: json

      expect(JSON.parse(response.body)['ts']).to eql('123')
    end

    it 'creates a message with a notification request' do
      json = { channel: 'general', message: 'Hello World', ts: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      post :create, params: json

      expect(Message.last.notification_request).to eql(NotificationRequest.last)
    end

    it 'saves the target identifier in the message' do
      json = { channel: 'general', message: 'Hello World', ts: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      post :create, params: json

      expect(Message.last.target_identifier).to eql('123')
    end

    it 'saves the json in the notification request' do
      json = { channel: 'general', message: 'Hello World', ts: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      post :create, params: json

      expect(NotificationRequest.last.json).to eql(
        '{"channel"=>"general", "message"=>"Hello World", "ts"=>"123", "controller"=>"channel_messages", "action"=>"create"}'
      )
    end

    it 'creates a message in the database' do
      json = { channel: 'general', message: 'Hello World', ts: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      expect do
        post :create, params: json
      end.to change(Message, :count).by(1)
    end

    it 'does not duplicate a message when it receives the uniq param' do
      json = { channel: 'general', message: 'Hello World', ts: '123', uniq: true }

      expect_any_instance_of(Clients::Slack::Channel)
        .not_to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      Message.create(text: 'Hello World', target: '#general', target_type: 'channel', provider_credential: provider,
                     action: 'create')

      expect do
        post :create, params: json
      end.to change(Message, :count).by(0)
    end

    it 'duplicates a message when uniq param is not sent or is false' do
      json = { channel: 'general', message: 'Hello World', ts: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      Message.create(text: 'Hello World', target: '#general', target_type: 'channel', provider_credential: provider,
                     action: 'create')

      expect do
        post :create, params: json
      end.to change(Message, :count).by(1)
    end
  end

  describe '#update' do
    it 'updates a message' do
      json = {
        id: '123456',
        channel: 'general',
        message: 'I am updating',
        ts: '123'
      }

      expect_any_instance_of(
        Clients::Slack::Channel
      ).to receive(:update!)
        .with('#general', 'I am updating', '123').and_return({
                                                               'ts' => '123'
                                                             })

      request.headers['Authorization'] = authorization

      post :update, params: json
    end

    it 'creates a message in the database' do
      json = {
        id: '123456',
        channel: 'general',
        message: 'I am updating',
        ts: '123'
      }

      expect_any_instance_of(
        Clients::Slack::Channel
      ).to receive(:update!)
        .with('#general', 'I am updating', '123').and_return({
                                                               'ts' => '123'
                                                             })

      request.headers['Authorization'] = authorization

      expect do
        post :update, params: json
      end.to change(Message, :count).by(1)
    end
  end
end
