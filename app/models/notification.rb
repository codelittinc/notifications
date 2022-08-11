# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id                      :bigint           not null, primary key
#  action                  :string
#  target                  :string
#  target_identifier       :string
#  target_type             :string
#  text                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  notification_request_id :bigint
#  provider_credential_id  :bigint
#
class Notification < ApplicationRecord
  belongs_to :provider_credential
  belongs_to :notification_request, optional: true

  validates :text, presence: true
  validates :target_type, presence: true, inclusion: { in: %w[direct channel reaction] }
  validates :action, presence: true, inclusion: { in: %w[create update] }
  validates :target, presence: true
end
