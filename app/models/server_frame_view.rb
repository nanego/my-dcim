# frozen_string_literal: truegd

class ServerFrameView < ApplicationRecord
  self.primary_key = :id
  self.table_name = "servers_frames_view"
  readonly

  scope :servers, -> { where(record_type: "Server") }
  scope :frames, -> { where(record_type: "Frame") }

  scope :search, lambda { |query|
    return if query.blank?

    # TODO
  }
end
