class Composant < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :name => proc { |controller, model_instance| model_instance.try(:name)}
  }

  validates_presence_of :type_composant_id

  belongs_to :enclosure
  has_one :modele, through: :enclosure
  belongs_to :type_composant

  has_many :cards

  acts_as_list scope: [:enclosure_id, :type_composant_id]
  
  scope :slots, -> { where(type_composant: TypeComposant.find_by_name('SLOT')) }

  def to_s
    name.nil? ? "" : name
  end

end
