class Frame < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :servers, -> { order("servers.position desc") }, dependent: :destroy
  belongs_to :bay
  has_one :islet, through: :bay
  delegate :room, :to => :islet, :allow_nil => true

  scope :sorted, -> { order( :position ) }

  def to_s
    title.nil? ? "" : title
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def name_with_room_and_islet
    "#{room.try(:title).present? ? "Salle #{room.title} " : ''} #{bay.present? ? "Ilot #{bay.islet.name}" : ''} Baie #{title.present? ? title : 'non précisée' }"
  end

  def self.to_txt(servers_per_bay)
    txt = ""
    if servers_per_bay.present?
      servers_per_bay.each do |islet, lanes|
        lanes.each do |lane, bays|
          bays.each do |bay, frames|
            frames.each do |frame, servers|
              txt << "\r\n#{frame.title}\r\n"
              txt << "---------------\r\n"
              servers.each do |server|
                txt << "[#{server.position.to_s.rjust(2, "0")}] #{server.nom}\r\n"
              end
            end
          end
        end
      end
    end
    txt
  end

  def other_frame_through_couple_baie #Temp legacy code
    couples = CoupleBaie.where('baie_one_id = ? OR baie_two_id = ?', self.id, self.id)
    frames = couples.collect(&:baie_one)
    frames << couples.collect(&:baie_two)
    (frames - [self]).first
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
          :title,
          [self.room.try(:title), :title],
          [self.room.try(:title), :title, :id]
      ]
    end

end
