# frozen_string_literal: true

class Frame < ApplicationRecord # rubocop:disable Metrics/ClassLength
  VIEW_SIDES = { both: "both", front: "front", back: "back" }.freeze

  extend FriendlyId

  friendly_id :slug_candidates, use: %i[slugged history]

  has_changelog

  belongs_to :bay
  has_many :materials, -> { order("servers.position desc") }, class_name: "Server", dependent: :restrict_with_error
  has_many :pdus, -> { only_pdus }, class_name: "Server", dependent: :restrict_with_error
  has_many :servers, -> { no_pdus.order("servers.position desc") }, class_name: "Server", dependent: :restrict_with_error
  has_one :islet, through: :bay
  has_one :room, through: :islet

  # TODO: Confirm this should be present and that we use dependent nullify. If yes, then we should update schema too.
  has_many :target_moves, class_name: "Move", inverse_of: :frame, dependent: :nullify
  has_many :origin_moves, class_name: "Move", foreign_key: :prev_frame_id, inverse_of: :prev_frame, dependent: :nullify

  delegate :name, to: :room, prefix: true, allow_nil: true

  validates :position, uniqueness: { scope: :bay_id }

  before_create :set_position

  scope :sorted, -> { order(:position) }

  delegate :to_s, to: :name

  def self.all_sorted
    Frame.includes(islet: :room, bay: :islet).sort_by(&:name_with_room_and_islet)
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def name_with_room_and_islet
    [
      room_name.present? ? "Salle #{room_name}" : "",
      bay.present? ? "Ilot #{bay.islet.name}" : "",
      "#{Frame.model_name.human} #{name.presence || "non précisée"}",
    ].compact_blank.join(" ")
  end

  def self.to_txt(servers_per_bay, detail)
    txt = []
    if servers_per_bay.present?
      servers_per_bay.each_value do |lanes|
        lanes.each_value do |bays|
          bays.each_value do |frames|
            frames.each_key do |frame|
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
    if present?
      txt << "\r\n#{name}\r\n"
      txt << "---------------\r\n"
      servers.each do |server|
        case detail
        when "gestion"
          addition = server.gestion.try(:name)
        when "cluster"
          addition = server.cluster.try(:name)
        end
        txt << "[#{server.position.to_s.rjust(2, "0")}] #{server.name} #{"(#{addition})" if addition.present?}\r\n"
      end
    end
    txt.join
  end

  def other_frame
    other_frames.first
  end

  def other_frames
    return [] unless bay

    bay.frames - [self]
  end

  def has_coupled_frame?
    bay.frames.many?
  end

  def has_no_coupled_frame?
    bay.frames.one?
  end

  def compact_u
    self.u = servers.sum { |s| s.modele.u }
    self
  end

  def init_pdus
    frame = self

    category = Category.find_or_create_by(name: "Pdu")
    puts "ERROR: #{category}" unless category.valid?
    modele = Modele.find_or_create_by(name: "Pdu 24",
                                      category: category)
    puts "ERROR: #{modele}" unless modele.valid?
    enclosure = Enclosure.find_or_create_by(modele: modele,
                                            position: 1,
                                            display: "vertical")
    puts "ERROR: #{enclosure}" unless enclosure.valid?
    4.times do |i|
      line = (i + 1).odd? ? "L1" : "L2"
      composant = Composant.find_or_create_by(position: i + 1,
                                              enclosure: enclosure,
                                              name: "ALIM_#{line}")
      puts "ERROR: #{composant}" unless composant.valid?
    end

    port_type = PortType.find_by_name("ALIM")
    puts "ERROR: #{port_type}" unless port_type.valid?
    card_type = CardType.find_or_create_by(name: "6ALIM",
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
                                     color: line_name == "A" ? "J" : "B")
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

  def last_position_used
    @last_position_used ||= bay.frames.maximum(:position) || 0
  end

  def next_free_position
    last_position_used + 1
  end

  def set_position
    return if position.present?

    self.position = next_free_position
  end

  def slug_candidates
    [
      :name,
      %i[name id],
    ]
  end
end
