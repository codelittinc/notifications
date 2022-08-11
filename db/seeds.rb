# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

provider = ProviderCredential.new(access_key: '123', team_id: '123', team_name: '123', application_key: '123')
Notification.new(provider_credential: provider, action: 'create', text: 'banana', target: 'noice',
                 target_type: 'channel').save
