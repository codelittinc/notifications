# frozen_string_literal: true

class Message < ApplicationRecord
  validates :text, presence: true
  validates :target_type, presence: true, inclusion: { in: %w[direct channel] }
  validates :action, presence: true, inclusion: { in: %w[create update] }
  validates :target, presence: true
end
