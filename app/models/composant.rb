class Composant < ActiveRecord::Base

  validates_presence_of :type_composant_id

  belongs_to :modele
  belongs_to :type_composant

  has_many :slots
  has_many :cards_serveurs

  acts_as_list scope: [:modele_id, :type_composant_id]

  accepts_nested_attributes_for :slots,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

end
