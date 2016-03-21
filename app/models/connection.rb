class Connection < ActiveRecord::Base
  belongs_to :source_port, class_name: "Port", foreign_key: "source_port_id"
  belongs_to :destination_port, class_name: "Port", foreign_key: "destination_port_id"
end
