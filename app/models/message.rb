# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id                      :bigint           not null, primary key
#  text                    :string
#  target_type             :string
#  action                  :string
#  target                  :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  provider_credential_id  :bigint
#  target_identifier       :string
#  notification_request_id :bigint
#
class Message < ApplicationRecord
  belongs_to :provider_credential
  belongs_to :notification_request, optional: true

  validates :text, presence: true
  validates :target_type, presence: true, inclusion: { in: %w[direct channel] }
  validates :action, presence: true, inclusion: { in: %w[create update] }
  validates :target, presence: true
end
