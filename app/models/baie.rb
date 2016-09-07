class Baie < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :servers, -> { order("servers.position desc") }, dependent: :destroy
  belongs_to :salle
  has_one :couple_baie, :foreign_key => :baie_one_id
  has_one :coupled_baie, through: :couple_baie, :source => :baie_two
  has_one :inverse_couple_baie, :class_name => "CoupleBaie", :foreign_key => "baie_two_id"
  has_one :inverse_coupled_baie, :through => :inverse_couple_baie, :source => :baie_one

  scope :sorted, -> {joins(:salle).order("salles.title asc", "baies.ilot asc", "baies.title asc")}

  def to_s
    title
  end

  def name_with_salle_and_ilot
    "#{salle.try(:title).present? ? "Salle #{salle.title} " : ''} #{ilot.present? ? "Ilot #{ilot}" : ''} Baie #{title.present? ? title : 'non précisée' }"
  end

  def self.to_txt(servers_per_bay)
    txt = ""
    if servers_per_bay.present?
      servers_per_bay.each do |ilot, baies|
        baies.each_with_index do |(baie, servers), index|
          txt << "\r\n#{baie.title}\r\n"
          txt << "---------------\r\n"
          servers.each do |server|
            txt << "[#{server.position.to_s.rjust(2, "0")}] #{server.nom}\r\n"
          end
        end
      end
    end
    txt
  end

  def other_baie
    coupled_baie || inverse_coupled_baie
  end

  def has_coupled_baie?
    ([coupled_baie] | [inverse_coupled_baie]).present?
  end

  def has_no_coupled_baie?
    ([coupled_baie] | [inverse_coupled_baie]).compact.empty?
  end

  def compact_u
    self.u = servers.map{|s|s.modele.u}.sum
    self
  end

  private

    def slug_candidates
      [
          :title,
          [self.salle.try(:title), :title],
          [self.salle.try(:title), :title, :id]
      ]
    end

end
