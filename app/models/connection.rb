# frozen_string_literal: true

class Connection < ApplicationRecord
  belongs_to :port
  belongs_to :cable

  def paired_connection
    cable.connections.where.not(id: self.id).first
  end
end
