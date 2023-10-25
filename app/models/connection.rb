# frozen_string_literal: true

class Connection < ApplicationRecord
  has_changelog

  belongs_to :port, optional: true
  belongs_to :cable, optional: true

  def paired_connection
    cable.connections.where.not(id: self.id).first
  end
end
