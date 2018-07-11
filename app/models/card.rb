class Card < ActiveRecord::Base

  after_commit :set_twin_card

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
  delegate :frame, to: :server

  has_many :ports
  has_many :cables, through: :ports

  scope :for_enclosure, ->  (enclosure_id) { joins(:composant).where("composants.enclosure_id = ?", enclosure_id).order("composants.position ASC")}

  scope :on_patch_panels, -> () {joins(:server => {:modele => :category}).where("categories.name = 'Patch Panel'")}

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

  def set_twin_card
    if twin_card_id.present?
      twin_card = Card.where(id: twin_card_id).first
      if twin_card.present? && twin_card.twin_card_id.blank?
        twin_card.twin_card_id = self.id
        twin_card.save
      end
      # Remove potential duplications
      Card.where(twin_card_id: [self.id, twin_card_id]).where.not(id: [self.id, twin_card_id]).update_all({twin_card_id: nil})
    end
  end

end
