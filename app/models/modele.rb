# frozen_string_literal: true

class Modele < ApplicationRecord
  extend FriendlyId

  friendly_id :slug_candidates, use: %i[slugged history]

  has_changelog

  has_many :servers, dependent: :restrict_with_error
  has_many :enclosures, dependent: :restrict_with_error
  has_many :composants, through: :enclosures

  belongs_to :manufacturer, counter_cache: true
  belongs_to :architecture, counter_cache: true
  belongs_to :category, counter_cache: true

  accepts_nested_attributes_for :enclosures,
                                allow_destroy: true,
                                reject_if: :all_blank

  validate :validate_network_types_values
  normalizes :network_types, with: ->(values) { values.compact_blank }

  scope :sorted, -> { order(:name) }
  scope :with_servers, -> { joins(:servers).uniq }
  scope :glpi_synchronizable, -> { where(category: Category.glpi_synchronizable) }
  scope :no_pdus, -> { joins(:category).where("categories.name<>'Pdu'") }
  scope :only_pdus, -> { joins(:category).where("categories.name='Pdu'").order(:name) }

  def self.all_sorted
    Modele.includes(:manufacturer).all.sort { |f1, f2| f1.name_with_brand.capitalize <=> f2.name_with_brand.capitalize }
  end

  def self.all_sorted_with_servers
    Modele.includes(:manufacturer).with_servers.sort { |f1, f2| f1.name_with_brand.capitalize <=> f2.name_with_brand.capitalize }
  end

  def to_s
    name.to_s
  end

  def is_a_pdu?
    category.pdu?
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def name_with_brand
    if manufacturer.present?
      "#{manufacturer} #{name}"
    else
      name.to_s
    end
  end

  def deep_dup
    dup.tap do |modele|
      modele.enclosures = enclosures.map(&:deep_dup)
    end
  end

  private

  def slug_candidates
    [
      :name,
      %i[name id],
    ]
  end

  def validate_network_types_values
    return if network_types.empty?
    return if network_types.any? { |n| Modele::Network::TYPES.include?(n) }

    errors.add(:network_types, :invalid)
  end
end
