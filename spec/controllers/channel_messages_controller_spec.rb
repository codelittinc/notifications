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
      json = { channel: 'general', message: 'Hello World', notification_id: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      post :create, params: json
    end

    it 'returns the id of the NotificationRequest' do
      json = { channel: 'general', message: 'Hello World', notification_id: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      provider_credential = ProviderCredential.new(access_key: '123', team_id: '123', team_name: '123',
                                                   application_key: '123')
      provider_credential.save!

      notification_request = NotificationRequest.new(
        provider_credential:,
        target_name: '#general',
        target_type: 'channel',
        action: 'create',
        content: 'Hello World',
        target_identifier: '123',
        uniq: false,
        json:
      )

      notification_request.save!

      allow_any_instance_of(ChannelMessagesController)
        .to receive(:notification_request)
        .and_return(notification_request)

      request.headers['Authorization'] = authorization

      post :create, params: json

      expect(JSON.parse(response.body)['notification_id']).to eql(notification_request.id.to_s)
    end

    it 'creates a message with a notification request' do
      json = { channel: 'general', message: 'Hello World', notification_id: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      post :create, params: json

      expect(Notification.last.notification_request).to eql(NotificationRequest.last)
    end

    it 'saves the target identifier in the message' do
      json = { channel: 'general', message: 'Hello World', notification_id: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      post :create, params: json

      expect(Notification.last.target_identifier).to eql('123')
    end

    it 'saves the json in the notification request' do
      json = { channel: 'general', message: 'Hello World', notification_id: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      post :create, params: json

      expect(NotificationRequest.last.json).to eql(
        '{"channel"=>"general", "message"=>"Hello World", "notification_id"=>"123", ' \
        '"controller"=>"channel_messages", "action"=>"create"}'
      )
    end

    it 'creates a message in the database' do
      json = { channel: 'general', message: 'Hello World', notification_id: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      expect do
        post :create, params: json
      end.to change(Notification, :count).by(1)
    end

    it 'does not duplicate a message when it receives the uniq param' do
      json = { channel: 'general', message: 'Hello World', notification_id: '123', uniq: true }

      request.headers['Authorization'] = authorization

      Notification.create(text: 'Hello World', target: '#general', target_type: 'channel', provider_credential: provider,
                          action: 'create')

      expect do
        post :create, params: json
      end.not_to change(Notification, :count)
    end

    it 'duplicates a message when uniq param is not sent or is false' do
      json = { channel: 'general', message: 'Hello World', notification_id: '123' }

      expect_any_instance_of(Clients::Slack::Channel)
        .to receive(:send!)
        .with('#general', 'Hello World', '123').and_return({
                                                             'ts' => '123'
                                                           })

      request.headers['Authorization'] = authorization

      Notification.create(text: 'Hello World', target: '#general', target_type: 'channel', provider_credential: provider,
                          action: 'create')

      expect do
        post :create, params: json
      end.to change(Notification, :count).by(1)
    end
  end

  describe '#update' do
    it 'updates a message' do
      json = {
        id: '123456',
        channel: 'general',
        message: 'I am updating',
        notification_id: '123'
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

    it 'finds the notification request in the database and use it to get the target_identifier' do
      notification_request = NotificationRequest.new(
        provider_credential: provider,
        target_name: '#general',
        target_type: 'channel',
        action: 'create',
        content: 'Hello World',
        uniq: false,
        json: ''
      )
      notification_request.save!
      message = Notification.new(text: 'Hello World', target_type: 'channel', action: 'update', target: '#general',
                                 target_identifier: 'batman.gothan', notification_request:,
                                 provider_credential: provider)
      message.save!

      json = {
        id: '123456',
        channel: 'general',
        message: 'I am updating',
        notification_id: notification_request.id
      }

      expect_any_instance_of(
        Clients::Slack::Channel
      ).to receive(:update!)
        .with('#general', 'I am updating', notification_request.notification.target_identifier).and_return({
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
        notification_id: '123'
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
      end.to change(Notification, :count).by(1)
    end

    it 'does not create a message in the database if there is any error when sending the message to slack' do
      json = {
        channel: 'general',
        message: 'I am trying to create and I am failing'
      }

      request.headers['Authorization'] = authorization

      expect do
        post :create, params: json
      end.not_to change(Notification, :count)
    end

    it 'returns an error if channel is empty' do
      json = {
        id: '123456',
        message: 'I am updating',
        notification_id: '123'
      }

      request.headers['Authorization'] = authorization

      post :create, params: json

      expect(response.body).to eql('{"error":"Validation failed: Target name is too short (minimum is 3 characters)"}')
    end
  end
end
