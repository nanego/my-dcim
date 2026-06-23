# frozen_string_literal: true

class PowerDistributionUnit
  class Circuit < ApplicationRecord
    has_changelog

    belongs_to :record, polymorphic: true
    has_many :sockets, class_name: "PowerDistributionUnit::Socket", dependent: :destroy

    validates :name, presence: true
  end
end
