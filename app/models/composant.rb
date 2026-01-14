# frozen_string_literal: true

class Composant < ApplicationRecord
  has_changelog
  acts_as_list scope: %i[enclosure_id]

  belongs_to :enclosure
  has_one :modele, through: :enclosure

  has_many :cards, dependent: :restrict_with_error

  validates :name, format: { without: /\s/ }, allow_blank: true

  scope :slots, -> { ordered } # TODO: remove
  scope :ordered, -> { order(position: :asc) }

  delegate :to_s, to: :name
end
