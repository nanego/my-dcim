class Server < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model

  belongs_to :frame
  has_one :bay, through: :frame
  has_one :room, through: :frame
  belongs_to :gestion
  belongs_to :domaine
  belongs_to :modele
  belongs_to :cluster
  belongs_to :server_state

  has_one :maintenance_contract
  has_many :memory_components
  has_many :disks

  has_many :slots
  has_many :cards, -> { joins(:composant).includes(:composant) }
  has_many :card_types, through: :cards
  has_many :ports, through: :cards

  has_many :moves, as: :moveable, dependent: :destroy

  has_many :documents

  validates_presence_of :numero
  validates_uniqueness_of :numero

  accepts_nested_attributes_for :cards,
                                :allow_destroy => true,
                                :reject_if     => :all_blank
  accepts_nested_attributes_for :disks,
                                :allow_destroy => true,
                                :reject_if     => :all_blank
  accepts_nested_attributes_for :memory_components,
                                :allow_destroy => true,
                                :reject_if     => :all_blank
  accepts_nested_attributes_for :documents,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  scope :sorted, -> { order( :position => :desc) }

  scope :no_pdus, -> { joins(:modele => :category).where("categories.name<>'Pdu'") }
  scope :only_pdus, -> { joins(:modele => :category).where("categories.name='Pdu'").order(:name) }

  validates :frame_id, presence: true
  validates :modele_id, presence: true
  validates :name , presence: true

  def to_s
    name.nil? ? "" : name
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def is_a_pdu?
    modele.is_a_pdu?
  end

  def is_not_a_pdu?
    !is_a_pdu?
  end

  require 'csv'
  def self.import(csv_file, room, server_state)
    room = room || Room.find_or_create_by!(name: 'Atelier')
    islet = room.islets.first
    bay = islet.bays.create!
    frame = bay.frames.create!(name: csv_file.original_filename.sub('.csv', ''))
    CSV.foreach(csv_file.path, {headers: true, col_sep: ';' }) do |row|
      server_data = row.to_hash
      modele = Modele.find_by_name(server_data['Modele'])
      raise "Modèle inconnu - #{server_data['Modele']}" if modele.blank?
      server = Server.new(frame: frame)
      server.server_state = server_state
      server.modele = modele
      server.name = server_data['Nom']
      server.critique = (server_data['Critique'] == 'oui')
      server.cluster = Cluster.find_or_create_by!(name: server_data['Cluster'])
      server.domaine = Domaine.find_or_create_by!(name: server_data['Domaine'])
      server.init_slots(server_data)
      unless server.save
        raise "Problème lors de l'ajout par fichier CSV"
      end
    end
    frame.compact_u.save
    return frame
  end

  def init_slots(server_data)
    type_composant_slot = TypeComposant.find_by_name('SLOT')
    7.times do |i|
      Composant.find_or_create_by!(modele: self.modele,
                                   type_composant: type_composant_slot,
                                   name: "SL#{i+1}"
      )
    end
    composant_slot_alim = Composant.find_or_create_by!(modele: self.modele,
                                                       type_composant: type_composant_slot,
                                                       name: "ALIM")
    composant_slot_cm = Composant.find_or_create_by!(modele: self.modele,
                                                     type_composant: type_composant_slot,
                                                     name: "CM")
    composant_slot_ipmi = Composant.find_or_create_by!(modele: self.modele,
                                                       type_composant: type_composant_slot,
                                                       name: "IPMI")

    # SLOTS SL
    slots = Composant.where(enclosure_id: Enclosure.where(modele_id: self.modele_id).order(:position).first.id, type_composant_id: type_composant_slot.id)
    7.times do |index|
      slot_name = "SL#{index+1}"
      slot_data = server_data[slot_name]
      if slot_data.present?
        if slot_data[0].is_integer?
          valeur = slot_data[1..-1]
          nb_ports = slot_data[0].to_i
        else
          valeur = slot_data
          nb_ports = 1
        end
        port_type = PortType.find_or_create_by!(name: valeur)
        card_type = CardType.find_or_create_by!(name: slot_data, port_quantity: nb_ports, port_type: port_type)
        Card.find_or_create_by!(card_type: card_type, server: self, composant: slots.where("name = ?", slot_name).first)
      end
    end

    # SLOTS CM
    valeur = 'RJ'
    nb_ports = server_data['CM'].gsub(valeur, '').to_i
    port_type = PortType.find_or_create_by!(name: valeur)
    card_cm = CardType.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
    Card.find_or_create_by!(card_type: card_cm, server: self, composant: composant_slot_cm)

    # SLOTS IPMI
    valeur = 'RJ'
    nb_ports = server_data['IPMI'].gsub(valeur, '').to_i
    port_type = PortType.find_or_create_by!(name: valeur)
    card_ipmi = CardType.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
    Card.find_or_create_by!(card_type: card_ipmi, server: self, composant: composant_slot_ipmi)

    # SLOTS ALIM
    valeur = 'ALIM'
    nb_ports = server_data['Alim'].gsub(valeur, '').to_i
    port_type = PortType.find_or_create_by!(name: valeur)
    card_alim = CardType.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
    Card.find_or_create_by!(card_type: card_alim, server: self, composant: composant_slot_alim)

  end

  def ports_per_type
    # Number of ports per type
    sums = {'XRJ' => 0,'RJ' => 0,'FC' => 0,'IPMI' => 0}
    cards.each do |card|
      if card.composant.name == 'IPMI'
        port_type = 'IPMI'
      else
        port_type = card.card_type.port_type.name
      end
      sums[port_type] = sums[port_type].to_i + card.ports.map(&:cable).compact.size
    end
    sums
  end

  def create_missing_ports
    cards.each { |card| card.create_missing_ports}
  end

  private

    def slug_candidates
      [
          :name,
          [:name, :id]
      ]
    end

end

class String
  def is_integer?
    self.to_i.to_s == self
  end
end
