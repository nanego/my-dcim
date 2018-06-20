class Card < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :card_type => :card_type,
      :server => :server,
      :composant => :composant
  }

  belongs_to :card_type
  delegate :port_quantity, :to => :card_type, :allow_nil => true
  delegate :is_power_input?, to: :card_type, :allow_nil => true

  belongs_to :server
  belongs_to :composant

  has_many :ports
  has_many :cables, through: :ports

  scope :for_enclosure, ->  (enclosure_id) { joins(:composant).where("composants.enclosure_id = ?", enclosure_id).order("composants.position ASC")}

  scope :on_patch_panels, -> () {joins(:server).where("servers.name LIKE 'PP-%'")}

  def to_s
    "Carte #{server} / #{card_type} / #{composant}"
  end

  def positions_with_ports
    ports.map {|port| port.position }
  end

  def create_missing_ports
    (1..port_quantity).each do |current_position|
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
