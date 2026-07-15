# frozen_string_literal: true

class Connection < ApplicationRecord
  has_changelog

  belongs_to :port, touch: true
  belongs_to :cable, touch: true

  has_one :card, through: :port, source: :attachable, source_type: "Card"
  has_one :server, through: :card
  has_one :card_type, through: :card

  has_one :socket, through: :port, source: :attachable, source_type: "PowerDistributionUnit::Socket"
  has_one :power_distribution_unit, through: :socket

  def paired_connection
    cable.connections.where.not(id: id).first
  end

  def port_type
    case port.attachable
    when Card
      card_type.port_type
    when PowerDistributionUnit::Socket
      socket.port_type
    end
  end
end
