# frozen_string_literal: true

# == Schema Information
#
# Table name: notification_requests
#
#  id                     :bigint           not null, primary key
#  action                 :string
#  content                :string
#  fulfilled              :boolean
#  json                   :string
#  target_identifier      :string
#  target_name            :string
#  target_type            :string
#  uniq                   :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider_credential_id :bigint           not null
#
class NotificationRequest < ApplicationRecord
  has_one :notification, dependent: :destroy

  belongs_to :provider_credential

  validates :target_name, length: { minimum: 3 }
end
