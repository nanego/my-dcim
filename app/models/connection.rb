# frozen_string_literal: true

class Connection < ApplicationRecord
  has_changelog

  belongs_to :port, touch: true
  belongs_to :cable, touch: true

  has_one :card, through: :port
  has_one :server, through: :port
  has_one :card_type, through: :card
  has_one :port_type, through: :card_type

  def paired_connection
    cable.connections.where.not(id: id).first
  end
end
