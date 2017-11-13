class Move < ApplicationRecord
  belongs_to :moveable, polymorphic: true

  belongs_to :frame
  belongs_to :prev_frame, class_name: 'Frame', foreign_key: :prev_frame_id

  validates_presence_of :frame, :moveable

  attr_accessor :remove_connections

  def reinit_connections
    server = self.moveable
    # Delete current moved connections
    MovedConnection.per_servers([server]).delete_all
    # Add moved connection for each port
    server.ports.each do |p|
      MovedConnection.create({port_from_id: p.id,
                              vlans: "",
                              color: "",
                              cablename: ""})
    end
  end

end
