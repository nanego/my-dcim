class Server < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model

  belongs_to :acte
  belongs_to :frame
  has_one :room, through: :frame
  belongs_to :gestion
  belongs_to :domaine
  belongs_to :modele
  belongs_to :cluster
  belongs_to :server_state

  has_one :maintenance_contract

  has_many :slots
  has_many :cards_servers, -> { joins(:composant).includes(:composant).order("composants.name asc, composants.position asc") }
  has_many :cards, through: :cards_servers
  has_many :ports, through: :cards_servers

  accepts_nested_attributes_for :cards_servers,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  scope :sorted, -> { order( :position => :desc) }

  validates :frame_id, presence: true
  validates :modele_id, presence: true
  validates :nom , presence: true

  def to_s
    nom.nil? ? "" : nom
  end

  def should_generate_new_friendly_id?
    slug.blank? || nom_changed?
  end

  require 'csv'
  def self.import(csv_file, room, server_state)
    room = room || Room.find_or_create_by!(title: 'Atelier')
    islet = room.islets.first
    bay = islet.bays.create!
    frame = bay.frames.create!(title: csv_file.original_filename.sub('.csv', ''))
    CSV.foreach(csv_file.path, {headers: true, col_sep: ';' }) do |row|
      server_data = row.to_hash
      modele = Modele.find_by_title(server_data['Modele'])
      raise "Modèle inconnu - #{server_data['Modele']}" if modele.blank?
      server = Server.new(frame: frame)
      server.server_state = server_state
      server.modele = modele
      server.nom = server_data['Nom']
      server.critique = (server_data['Critique'] == 'oui')
      server.cluster = Cluster.find_or_create_by!(title: server_data['Cluster'])
      server.domaine = Domaine.find_or_create_by!(title: server_data['Domaine'])
      server.init_slots(server_data)
      unless server.save
        raise "Problème lors de l'ajout par fichier CSV"
      end
    end
    frame.compact_u.save
    return frame
  end

  def init_slots(server_data)
    type_composant_slot = TypeComposant.find_by_title('SLOT')
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
    slots = Composant.where(modele_id: self.modele_id, type_composant_id: type_composant_slot.id)
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
        card = Card.find_or_create_by!(name: slot_data, port_quantity: nb_ports, port_type: port_type)
        CardsServer.find_or_create_by!(card: card, server: self, composant: slots.where("name = ?", slot_name).first)
      end
    end

    # SLOTS CM
    valeur = 'RJ'
    nb_ports = server_data['CM'].gsub(valeur, '').to_i
    port_type = PortType.find_or_create_by!(name: valeur)
    card_cm = Card.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
    CardsServer.find_or_create_by!(card: card_cm, server: self, composant: composant_slot_cm)

    # SLOTS IPMI
    valeur = 'RJ'
    nb_ports = server_data['IPMI'].gsub(valeur, '').to_i
    port_type = PortType.find_or_create_by!(name: valeur)
    card_ipmi = Card.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
    CardsServer.find_or_create_by!(card: card_ipmi, server: self, composant: composant_slot_ipmi)

    # SLOTS ALIM
    valeur = 'ALIM'
    nb_ports = server_data['Alim'].gsub(valeur, '').to_i
    port_type = PortType.find_or_create_by!(name: valeur)
    card_alim = Card.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
    CardsServer.find_or_create_by!(card: card_alim, server: self, composant: composant_slot_alim)

  end

  def ports_per_type
    # Number of ports per type
    sums = {'XRJ' => 0,'RJ' => 0,'FC' => 0,'IPMI' => 0}
    self.cards_servers.each do |card_server|
      if card_server.composant.name == 'IPMI'
        port_type = 'IPMI'
      else
        port_type = card_server.card.port_type.name
      end
      sums[port_type] = sums[port_type].to_i + card_server.ports.map(&:cablename).compact.uniq.size
    end
    sums
  end

  private

    def slug_candidates
      [
          :nom,
          [:nom, :id]
      ]
    end

end

class String
  def is_integer?
    self.to_i.to_s == self
  end
end
