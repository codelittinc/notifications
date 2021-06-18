# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  config = Clients::Slack::Config.instance
  config.client_id = ENV['SLACK_CLIENT_ID']
  config.client_secret = ENV['SLACK_CLIENT_SECRET']
end
