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

  has_many :slots
  has_many :cards

  acts_as_list scope: [:enclosure_id, :type_composant_id]

  accepts_nested_attributes_for :slots,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  def to_s
    name.nil? ? "" : name
  end

end
