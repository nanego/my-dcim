class Connection < ApplicationRecord

  belongs_to :cable
  belongs_to :port

  def paired_connection
    cable.connections.reject{|connection|connection==self}.first
  end

end
