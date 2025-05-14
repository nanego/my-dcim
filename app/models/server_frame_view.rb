# frozen_string_literal: true

class ServerFrameView < ApplicationRecord
  self.primary_key = :id
  self.table_name = "servers_frames_view"
  readonly

  scope :servers, -> { Server.includes(modele: :manufacturer).find(where(record_type: "Server").pluck(:id)) }
  scope :frames, -> { Frame.includes(bay: { islet: { room: :site } }).find(where(record_type: "Frame").pluck(:id)) }

  scope :search, lambda { |query|
    return if query.blank?

    where(
      'name ILIKE :query OR
      numero ILIKE :query OR
      modele_name ILIKE :query OR
      manufacturer_name ILIKE :query OR
      islet_name ILIKE :query OR
      room_name ILIKE :query',
      query: "%#{query}%"
    )
  }
end
