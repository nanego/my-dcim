# frozen_string_literal: true

class Cable < ApplicationRecord
  has_many :connections, dependent: :destroy
  has_many :ports, through: :connections

  after_update :touch_ports

  def touch_ports
    ports.each(&:touch)
  end

end
