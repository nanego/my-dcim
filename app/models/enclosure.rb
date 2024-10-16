# frozen_string_literal: true

class Enclosure < ApplicationRecord
  has_changelog
  acts_as_list scope: [:modele_id]

  belongs_to :modele
  has_many :composants, -> { order(position: :asc) }

  accepts_nested_attributes_for :composants,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  def deep_dup
    dup.tap do |enclosure|
      enclosure.composants = composants.map(&:dup)
    end
  end
end
