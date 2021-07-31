# frozen_string_literal: true

class NotificationRequest < ApplicationRecord
  belongs_to :provider_credential
end
