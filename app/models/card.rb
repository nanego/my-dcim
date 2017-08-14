class Card < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :card_type => :card_type,
      :server => :server,
      :composant => :composant
  }

  belongs_to :card_type
  belongs_to :server
  belongs_to :composant

  has_many :ports

  scope :for_enclosure, ->  (enclosure_id) { joins(:composant).where("composants.enclosure_id = ?", enclosure_id)}

  def to_s
    "Carte #{server} / #{card_type} / #{composant}"
  end

  def create_missing_ports
    # port_type = self.card_type.try(:port_type)
    port_quantity = self.card_type.try(:port_quantity)
    existing_ports = self.ports
    port_quantity.to_i.times do |index|
      current_position = index+1
      current_port = existing_ports.detect {|p| p.position == current_position}
      if current_port.nil?
        puts "create port #{current_position}"
        Port.create(position: current_position,
                    card_id: self.id,
                    vlans: nil,
                    color: nil,
                    cablename: nil)
      end
    end
  end

end
