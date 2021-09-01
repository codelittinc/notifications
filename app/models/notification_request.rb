# frozen_string_literal: true

class NotificationRequest < ApplicationRecord
  has_one :message, dependent: :destroy

  belongs_to :provider_credential
end
