# frozen_string_literal: true

class Composant < ApplicationRecord
  has_changelog
  acts_as_list scope: %i[enclosure_id]

  belongs_to :enclosure
  has_one :modele, through: :enclosure

  has_many :cards

  validates :name, format: { without: /\s/ }, allow_blank: true

  scope :slots, -> { order("composants.position ASC") }
  scope :ordered, -> { order(position: :asc) }

  def to_s
    name.to_s
  end
end
