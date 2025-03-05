# frozen_string_literal: true

class Frame < ApplicationRecord
  DEFAULT_SETTINGS = { max_u: 38, max_elts: 24, max_rj45: 48, max_fc: 12 }.freeze
  VIEW_SIDES = { both: 'both', front: 'front', back: 'back' }.freeze

  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged history]

  has_changelog
  acts_as_list scope: [:bay_id]

  belongs_to :bay
  has_many :materials, -> { order("servers.position desc") }, class_name: "Server", dependent: :restrict_with_error
  has_many :pdus, -> { only_pdus }, class_name: "Server", dependent: :restrict_with_error
  has_many :servers, -> { no_pdus.order("servers.position desc") }, class_name: "Server", dependent: :restrict_with_error
  has_one :islet, through: :bay
  has_one :room, through: :islet
  delegate :name, :to => :room, :prefix => true, :allow_nil => true

  scope :sorted, -> { order(:position) }

  scope :search, lambda { |query|
    return if query.blank?

    joins(bay: { islet: { room: :site } }).where(
      'frames.name ILIKE :query OR
        islets.name ILIKE :query OR
        rooms.name ILIKE :query OR
        sites.name ILIKE :query',
      query: "%#{query}%"
    )
  }

  def to_s
    name.to_s
  end

  def self.all_sorted
    Frame.includes(:islet => :room, :bay => :islet).sort_by(&:name_with_room_and_islet)
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def name_with_room_and_islet
    [
      room_name.present? ? "Salle #{room_name}" : '',
      bay.present? ? "Ilot #{bay.islet.name}" : '',
      Frame.model_name.human + " " + (name.presence || 'non précisée'),
    ].compact_blank.join(' ')
  end

  def self.to_txt(servers_per_bay, detail)
    txt = []
    if servers_per_bay.present?
      servers_per_bay.each do |_islet, lanes|
        lanes.each do |_lane, bays|
          bays.each do |_bay, frames|
            frames.each do |frame, _servers|
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
        when 'gestion'
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
    self.u = servers.sum { |s| s.modele.u }
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
    4.times do |i|
      line = (i + 1).odd? ? 'L1' : 'L2'
      composant = Composant.find_or_create_by(position: i + 1,
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

    %w[A B].each do |line_name|
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
      %i[name id],
    ]
  end
end
