# frozen_string_literal: true

class Cable < ApplicationRecord
  log_changes

  has_many :connections, dependent: :destroy
  has_many :ports, through: :connections
end
