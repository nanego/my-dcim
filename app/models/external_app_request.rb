# frozen_string_literal: true

class ExternalAppRequest < ApplicationRecord
  # A job that stopped making progress for that long died with its process
  STALE_AFTER = 10.minutes
  belongs_to :user

  enum :status, {
    pending: "pending",
    in_progress: "in_progress",
    completed: "completed",
    failed: "failed",
  }

  after_initialize :set_defaults

  scope :pending, -> { where(status: :pending) }
  scope :in_progress, -> { where(status: :in_progress) }
  scope :completed, -> { where(status: :completed) }
  scope :failed, -> { where(status: :failed) }
  scope :running, -> { where(status: %i[pending in_progress]) }
  scope :stale, -> { running.where(updated_at: ...STALE_AFTER.ago) }
  scope :active, -> { running.where(updated_at: STALE_AFTER.ago..) }

  def fail!(message)
    update(status: :failed, error_message: message.to_s.truncate(500))
  end

  private

  def set_defaults
    self.status ||= :pending
    self.progress ||= 0
  end
end
