# frozen_string_literal: true

class Composant < ApplicationRecord
  has_changelog
  acts_as_list scope: %i[enclosure_id type_composant_id]

  belongs_to :enclosure
  belongs_to :type_composant
  has_one :modele, through: :enclosure

  has_many :cards

  validates :name, format: { without: /\s/ }, allow_blank: true

  scope :slots, -> { where(type_composant: TypeComposant.find_by_name('SLOT')).order("composants.position ASC") }
  scope :ordered, -> { order(position: :asc) }

  def to_s
    name.to_s
  end
end
