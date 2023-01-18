# frozen_string_literal: true

class Maintainer < ApplicationRecord
  has_many :maintenance_contracts

  def to_s
    name
  end
end
