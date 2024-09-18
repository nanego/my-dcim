# frozen_string_literal: true

class EnclosureComponent < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
    :name => proc { |controller, model_instance| model_instance.try(:name) }
  }
  has_changelog
  acts_as_list scope: [:enclosure_id, :type_composant_id]

  belongs_to :enclosure
  belongs_to :type_composant
  has_one :modele, through: :enclosure

  has_many :cards

  scope :slots, -> { where(type_composant: TypeComposant.find_by_name('SLOT')).order("enclosure_components.position ASC") }

  def to_s
    name.to_s
  end
end
