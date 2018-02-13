class Enclosure < ApplicationRecord

  belongs_to :modele
  has_many :composants, -> { order(position: :asc) }

  acts_as_list scope: [:modele_id]

  accepts_nested_attributes_for :composants,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

end
