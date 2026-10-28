# frozen_string_literal: true

class Enclosure < ApplicationRecord
  has_changelog
  acts_as_list scope: [:modele_id]

  belongs_to :modele
  has_many :composants, dependent: :destroy

  enum :display, { vertical: "vertical", horizontal: "horizontal", grid: "grid" }, validate: true

  scope :with_composants, -> { where.associated(:composants).distinct }

  accepts_nested_attributes_for :composants,
                                allow_destroy: true,
                                reject_if: :all_blank

  validate :grid_areas_match_composants

  def deep_dup
    dup.tap do |enclosure|
      enclosure.composants = composants.map(&:dup)
    end
  end

  private

  def grid_areas_match_composants
    return unless grid?

    text_set = grid_areas.split.to_set
    composants_set = composants.filter_map { |c| c.name.presence }.to_set

    errors.add(:grid_areas, :lack_composants) unless (composants_set - text_set).empty?
    errors.add(:grid_areas, :unknown_composants) unless (text_set - composants_set).empty?
  end
end
