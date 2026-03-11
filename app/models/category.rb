# frozen_string_literal: true

class Category < ApplicationRecord
  has_changelog

  enum :glpi_sync, {
    no: 0,
    server: 1,
    network_equipment: 2,
  }, suffix: true

  has_many :modeles, dependent: :restrict_with_error

  scope :sorted, -> { order(:name) }
  scope :glpi_synchronizable, -> { where.not(glpi_sync: :no) }

  delegate :to_s, to: :name

  def pdu?
    name == "Pdu"
  end
end
