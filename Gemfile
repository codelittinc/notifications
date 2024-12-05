# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.0'

gem 'rails', '~> 6.1.0'

gem 'rails_admin', '~> 2.0'

gem 'faraday', '>= 2.7.4'
gem 'net-imap'
gem 'net-pop'
gem 'net-smtp'

gem 'pg', '~> 1.2'
gem 'puma', '~> 4.1'
gem 'sidekiq'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'redis-rails'

gem 'data_migrate'

gem 'ruby_notifications_client', git: 'https://github.com/codelittinc/ruby_notifications_client.git'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'slack-ruby-client', '2.0.0'

gem 'rails_semantic_logger'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'rubocop-rails', require: false
  gem 'shoulda-matchers'
end

group :development do
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

