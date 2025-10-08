# frozen_string_literal: true

class Category < ApplicationRecord
  has_changelog

  has_many :modeles, dependent: :restrict_with_error

  scope :sorted, -> { order(:name) }
  scope :glpi_synchronizable, -> { where(is_glpi_synchronizable: true) }

  delegate :to_s, to: :name

  def pdu?
    name == "Pdu"
  end
end
