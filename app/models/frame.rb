class Frame < ActiveRecord::Base

  enum settings: { max_u: 38, max_elts: 24, max_rj45: 48, max_fc: 12 }
  enum view_sides: { both: 'both', front: 'front', back: 'back' }

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :materials, -> { order("servers.position desc") }, class_name: "Server"
  has_many :pdus, -> { only_pdus }, class_name: "Server"
  has_many :servers, -> { no_pdus.order("servers.position desc") }, class_name: "Server"
  belongs_to :bay
  has_one :islet, through: :bay
  delegate :room, :to => :islet, :allow_nil => true
  delegate :name, :to => :room, :prefix => true, :allow_nil => true

  acts_as_list scope: [:bay_id]

  scope :sorted, -> { order( :position ) }

  validates_presence_of :bay_id

  def to_s
    name.to_s
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def name_with_room_and_islet
    [room_name.present? ? "Salle #{room_name}" : '',
     bay.present? ? "Ilot #{bay.islet.name}" : '',
     "Baie " + (name.present? ? name : 'non précisée')
    ].reject(&:blank?).join(' ')
  end

  def self.to_txt(servers_per_bay)
    txt = ""
    if servers_per_bay.present?
      servers_per_bay.each do |islet, lanes|
        lanes.each do |lane, bays|
          bays.each do |bay, frames|
            frames.each do |frame, servers|
              txt << frame.to_txt
            end
          end
        end
      end
    end
    txt
  end

  def to_txt
    txt = ""
    if self.present?
      txt << "\r\n#{self.name}\r\n"
      txt << "---------------\r\n"
      self.servers.each do |server|
        txt << "[#{server.position.to_s.rjust(2, "0")}] #{server.name}\r\n"
      end
    end
    txt
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
    self.u = servers.map{|s|s.modele.u}.sum
    self
  end

  private

    def slug_candidates
      [
          :name,
          [:name, :id]
      ]
    end

end
