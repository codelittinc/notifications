# frozen_string_literal: true

# == Schema Information
#
# Table name: notification_requests
#
#  id                     :bigint           not null, primary key
#  fulfilled              :boolean
#  uniq                   :boolean
#  target_name            :string
#  target_type            :string
#  content                :string
#  action                 :string
#  target_identifier      :string
#  provider_credential_id :bigint           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  json                   :string
#
class NotificationRequest < ApplicationRecord
  has_one :message, dependent: :destroy

  belongs_to :provider_credential
end
