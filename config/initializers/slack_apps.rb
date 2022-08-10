# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  config = Clients::Slack::Config.instance
  config.client_id = ENV.fetch('SLACK_CLIENT_ID', nil)
  config.client_secret = ENV.fetch('SLACK_CLIENT_SECRET', nil)
end
