class Composant < ActiveRecord::Base

  validates_presence_of :modele_id, :type_composant_id

  belongs_to :modele
  belongs_to :type_composant

  acts_as_list scope: :modele

end
