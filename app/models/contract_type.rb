# frozen_string_literal: true

class ContractType < ApplicationRecord
  has_many :maintenance_contracts

  def to_s
    name
  end
end
