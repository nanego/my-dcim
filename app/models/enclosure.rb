class Enclosure < ApplicationRecord

  belongs_to :modele
  has_many :composants, -> { order(name: :asc, position: :asc) }

  accepts_nested_attributes_for :composants,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

end
