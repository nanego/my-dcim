class Connection < ActiveRecord::Base
  belongs_to :source_port, class_name: "Port", foreign_key: "id"
  belongs_to :destination_port, class_name: "Port", foreign_key: "id"
end
