class Frame < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :bay

  has_many :servers, -> { order("servers.position desc") }, dependent: :destroy
  belongs_to :room
  has_one :couple_frame, :class_name => "CoupleBaie", :foreign_key => :baie_one_id
  has_one :coupled_frame, through: :couple_frame, :source => :baie_two
  has_one :inverse_couple_frame, :class_name => "CoupleBaie", :foreign_key => "baie_two_id"
  has_one :inverse_coupled_frame, :through => :inverse_couple_frame, :source => :baie_one

  scope :sorted, -> {joins(:room).order("rooms.title asc", "frames.ilot asc", "frames.title asc")}

  def to_s
    title
  end

  def name_with_room_and_ilot
    "#{room.try(:title).present? ? "Salle #{room.title} " : ''} #{ilot.present? ? "Ilot #{ilot}" : ''} Baie #{title.present? ? title : 'non précisée' }"
  end

  def self.to_txt(servers_per_bay)
    txt = ""
    if servers_per_bay.present?
      servers_per_bay.each do |ilot, frames|
        frames.each_with_index do |(frame, servers), index|
          txt << "\r\n#{frame.title}\r\n"
          txt << "---------------\r\n"
          servers.each do |server|
            txt << "[#{server.position.to_s.rjust(2, "0")}] #{server.nom}\r\n"
          end
        end
      end
    end
    txt
  end

  def other_frame
    coupled_frame || inverse_coupled_frame
  end

  def has_coupled_frame?
    ([coupled_frame] | [inverse_coupled_frame]).compact.present?
  end

  def has_no_coupled_frame?
    ([coupled_frame] | [inverse_coupled_frame]).compact.empty?
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
