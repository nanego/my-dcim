# frozen_string_literal: true

class ExternalAppRequest < ApplicationRecord
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

  private

  def set_defaults
    self.status ||= :pending
    self.progress ||= 0
  end
end
