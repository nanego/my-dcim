# frozen_string_literal: true

class Cable < ApplicationRecord
  COLORS = {
    N: :black,
    M: :brown,
    R: :red,
    O: :orange,
    J: :yellow,
    V: :green,
    T: :turquoise,
    B: :blue,
    Vi: :purple,
    P: :pink,
    G: :grey,
    W: :white,
  }.freeze

  has_changelog

  has_many :connections, dependent: :destroy
  has_many :ports, through: :connections
  has_many :servers, through: :connections
  has_many :cards, through: :connections
  has_many :card_types, through: :cards
  has_many :port_types, through: :card_types

  after_update :touch_ports

  scope :sorted, lambda {
    alim_cables = joins(:port_types).where(port_types: PortType.where(name: "ALIM")).uniq
    other_cables = order(:cards, ports: { position: :asc }).select { |c| alim_cables.exclude?(c) }

    other_cables + alim_cables
  }

  def touch_ports
    ports.each(&:touch)
  end
end
