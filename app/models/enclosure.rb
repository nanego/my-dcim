# frozen_string_literal: true

class Enclosure < ApplicationRecord
  has_changelog
  acts_as_list scope: [:modele_id]

  belongs_to :modele
  has_many :components, -> { order(position: :asc) }, class_name: "EnclosureComponent"

  accepts_nested_attributes_for :components,
                                :allow_destroy => true,
                                :reject_if     => :all_blank
end
