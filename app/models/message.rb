# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :provider_credential
  belongs_to :notification_request, optional: true

  validates :text, presence: true
  validates :target_type, presence: true, inclusion: { in: %w[direct channel] }
  validates :action, presence: true, inclusion: { in: %w[create update] }
  validates :target, presence: true
end
