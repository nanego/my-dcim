# frozen_string_literal: true

class Composant < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :name => proc { |controller, model_instance| model_instance.try(:name)}
  }

  validates_presence_of :type_composant_id

  belongs_to :enclosure, optional: true
  belongs_to :type_composant, optional: true
  has_one :modele, through: :enclosure

  has_many :cards

  acts_as_list scope: [:enclosure_id, :type_composant_id]

  scope :slots, -> { where(type_composant: TypeComposant.find_by_name('SLOT')).order("composants.position ASC") }

  def to_s
    name.to_s
  end
end
