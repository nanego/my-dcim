class Connection < ApplicationRecord

  belongs_to :cable
  belongs_to :port

  def paired_connection
    cable.connections.where.not(id: self.id).first
  end

end
