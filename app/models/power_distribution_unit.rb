# frozen_string_literal: true

class PowerDistributionUnit < ApplicationRecord
  belongs_to :type, class_name: "PowerDistributionUnitType"
  belongs_to :bay

  enum :orientation, { asc: 0, desc: 1 }, validate: true
  enum :side, { left: 0, right: 1 }, validate: true

  validates :name, presence: true

  delegate :to_s, to: :name
end
