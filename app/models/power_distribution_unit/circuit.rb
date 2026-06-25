# frozen_string_literal: true

class PowerDistributionUnit
  class Circuit < ApplicationRecord
    has_changelog

    belongs_to :record, polymorphic: true
    has_many :sockets, dependent: :destroy

    validates :name, presence: true

    accepts_nested_attributes_for :sockets, allow_destroy: true

    def deep_dup
      copy = dup

      copy.tap do |circuit|
        circuit.sockets = sockets.map(&:dup)
      end
    end
  end
end
