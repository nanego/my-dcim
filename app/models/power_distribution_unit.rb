# frozen_string_literal: true

class PowerDistributionUnit < ApplicationRecord
  extend FriendlyId

  friendly_id :slug_candidates, use: %i[slugged history]

  has_changelog

  belongs_to :type, class_name: "PowerDistributionUnitType"
  belongs_to :bay

  has_many :circuits, as: :record, class_name: "PowerDistributionUnit::Circuit", dependent: :destroy

  has_one :manufacturer, through: :type
  has_one :islet, through: :bay
  has_one :room, through: :bay

  enum :orientation, { asc: 0, desc: 1 }, validate: true
  enum :side, { left: 0, right: 1 }, validate: true

  accepts_nested_attributes_for :circuits,
                                allow_destroy: true

  validates :name, presence: true
  validates :serial_number, presence: true, uniqueness: true, format: { without: /\s/ }
  validates :ipmi_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true

  delegate :to_s, to: :name

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  private

  def slug_candidates
    [
      :name,
      %i[name id],
    ]
  end
end
