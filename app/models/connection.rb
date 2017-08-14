class Connection < ApplicationRecord

  belongs_to :cable
  belongs_to :port

  def paired_connection
    cable.connections.reject{|c|c==self}.first
  end

end
