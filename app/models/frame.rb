# frozen_string_literal: true

class Frame < ApplicationRecord
  enum settings: {max_u: 38, max_elts: 24, max_rj45: 48, max_fc: 12}
  enum view_sides: {both: 'both', front: 'front', back: 'back'}

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  belongs_to :bay, optional: true
  has_many :materials, -> {order("servers.position desc")}, class_name: "Server", dependent: :restrict_with_error
  has_many :pdus, -> {only_pdus}, class_name: "Server", dependent: :restrict_with_error
  has_many :servers, -> {no_pdus.order("servers.position desc")}, class_name: "Server", dependent: :restrict_with_error
  has_one :islet, through: :bay
  delegate :room, :to => :islet, :allow_nil => true
  delegate :name, :to => :room, :prefix => true, :allow_nil => true

  acts_as_list scope: [:bay_id]

  scope :sorted, -> {order(:position)}

  validates_presence_of :bay_id

  def to_s
    name.to_s
  end

  def self.all_sorted
    Frame.includes(:islet => :room, :bay => :islet).sort{|f1,f2|f1.name_with_room_and_islet <=> f2.name_with_room_and_islet}
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def name_with_room_and_islet
    [room_name.present? ? "Salle #{room_name}" : '',
     bay.present? ? "Ilot #{bay.islet.name}" : '',
     "Baie " + (name.present? ? name : 'non précisée')].reject(&:blank?).join(' ')
  end

  def self.to_txt(servers_per_bay, detail)
    txt = []
    if servers_per_bay.present?
      servers_per_bay.each do |islet, lanes|
        lanes.each do |lane, bays|
          bays.each do |bay, frames|
            frames.each do |frame, servers|
              txt << frame.to_txt(detail)
            end
          end
        end
      end
    end
    txt.join
  end

  def to_txt(detail)
    txt = []
    if self.present?
      txt << "\r\n#{self.name}\r\n"
      txt << "---------------\r\n"
      self.servers.each do |server|
        case detail
        when 'gestionnaire'
          addition = server.gestion.try(:name)
        when 'cluster'
          addition = server.cluster.try(:name)
        end
        txt << "[#{server.position.to_s.rjust(2, "0")}] #{server.name} #{"(#{addition})" if addition.present?}\r\n"
      end
    end
    txt.join
  end

  def other_frame
    (bay.frames - [self]).first
  end

  def other_frames
    bay.frames - [self]
  end

  def has_coupled_frame?
    bay.frames.count > 1
  end

  def has_no_coupled_frame?
    bay.frames.count == 1
  end

  def compact_u
    self.u = servers.map {|s| s.modele.u}.sum
    self
  end

  def init_pdus
    frame = self

    category = Category.find_or_create_by(name: 'Pdu')
    puts "ERROR: #{category}" unless category.valid?
    modele = Modele.find_or_create_by(name: 'Pdu 24',
                                      category: category)
    puts "ERROR: #{modele}" unless modele.valid?
    enclosure = Enclosure.find_or_create_by(modele: modele,
                                            position: 1,
                                            display: 'vertical')
    puts "ERROR: #{enclosure}" unless enclosure.valid?
    type_composant = TypeComposant.find_by_name('SLOT')
    puts "ERROR: #{type_composant}" unless type_composant.valid?
    4.times do |i|
      line = (i + 1).odd? ? 'L1' : 'L2'
      composant = Composant.find_or_create_by(type_composant: type_composant,
                                              position: i + 1,
                                              enclosure: enclosure,
                                              name: "ALIM_#{line}")
      puts "ERROR: #{composant}" unless composant.valid?
    end

    port_type = PortType.find_by_name('ALIM')
    puts "ERROR: #{port_type}" unless port_type.valid?
    card_type = CardType.find_or_create_by(name: '6ALIM',
                                           port_quantity: 6,
                                           port_type: port_type)
    puts "ERROR: #{card_type}" unless card_type.valid?

    ['A', 'B'].each do |line_name|
      pdu_name = "PDU_#{frame}_#{line_name}"
      pdu = Server.find_or_create_by(frame: frame,
                                     modele: modele,
                                     numero: pdu_name,
                                     name: pdu_name,
                                     side: Pdu.calculated_side(frame, line_name),
                                     color: line_name == 'A' ? 'J' : 'B')
      puts "ERROR: #{pdu}" unless pdu.valid?
      enclosure.composants.each do |composant|
        card = Card.find_or_create_by(card_type: card_type,
                           server: pdu,
                           composant: composant)
        puts "ERROR: #{card}" unless card.valid?
      end
    end
  end

  private

  def slug_candidates
    [
        :name,
        [:name, :id]
    ]
  end
end
