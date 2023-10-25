# frozen_string_literal: true

class Composant < ApplicationRecord
  has_changelog
  acts_as_list scope: [:enclosure_id, :type_composant_id]

  belongs_to :enclosure, optional: true
  belongs_to :type_composant, optional: true
  has_one :modele, through: :enclosure

  has_many :cards

  validates_presence_of :type_composant_id # TODO: this do the oposite of optional: true

  scope :slots, -> { where(type_composant: TypeComposant.find_by_name('SLOT')).order("composants.position ASC") }

  def to_s
    name.to_s
  end
end
