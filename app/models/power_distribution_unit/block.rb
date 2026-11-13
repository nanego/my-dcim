# frozen_string_literal: true

class PowerDistributionUnit
  class Block < ApplicationRecord
    has_changelog
    acts_as_list scope: %i[record_type record_id]

    belongs_to :record, polymorphic: true
    has_many :sockets, -> { order(:number) }, dependent: :destroy, inverse_of: :block

    accepts_nested_attributes_for :sockets, allow_destroy: true

    default_scope { order(:position) }

    def deep_dup
      copy = dup

      copy.tap do |circuit|
        circuit.sockets = sockets.map(&:dup)
      end
    end
  end
end
