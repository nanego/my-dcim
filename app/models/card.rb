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

  scope :for_enclosure, ->  (enclosure_id) { joins(:composant).where("composants.enclosure_id = ?", enclosure_id).order("composants.position ASC")}

  def to_s
    "Carte #{server} / #{card_type} / #{composant}"
  end

  def is_power_input?
    card_type.is_power_input?
  end

  def number_of_ports
    card_type.try(:port_quantity).to_i
  end

  def positions_with_ports
    ports.map {|port| port.position }
  end

  def create_missing_ports
    (1..number_of_ports).each do |current_position|
      unless positions_with_ports.include?(current_position)
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
