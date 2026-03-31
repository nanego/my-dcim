# frozen_string_literal: true

class Category < ApplicationRecord
  has_changelog

  enum :glpi_sync_type, {
    none: 0,
    server: 1,
    network_equipment: 2,
  }, prefix: true

  has_many :modeles, dependent: :restrict_with_error

  scope :sorted, -> { order(:name) }
  scope :glpi_synchronizable, -> { where.not(glpi_sync_type: :none) }

  delegate :to_s, to: :name

  def pdu?
    name == "Pdu"
  end
end
