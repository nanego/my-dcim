# frozen_string_literal: true

class PowerDistributionUnit
  class Socket < ApplicationRecord
    belongs_to :circuit
    belongs_to :port_type

    validates :name, presence: true
  end
end
