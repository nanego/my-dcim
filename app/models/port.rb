class Port < ActiveRecord::Base

  belongs_to :parent, :polymorphic => true

  has_many :connections_from, :class_name => 'Connection', :foreign_key => 'source_port_id'
  has_many :connections_to, :class_name => 'Connection', :foreign_key => 'destination_port_id'
  def connections
    connections_from + connections_to
  end

end
