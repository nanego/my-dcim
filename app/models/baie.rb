class Baie < ActiveRecord::Base

  has_many :serveurs, -> { order("serveurs.position desc") }
  belongs_to :salle
  has_one :couple_baie, :foreign_key => :baie_one_id
  has_one :coupled_baie, through: :couple_baie, :source => :baie_two
  has_one :inverse_couple_baie, :class_name => "CoupleBaie", :foreign_key => "baie_two_id"
  has_one :inverse_coupled_baie, :through => :inverse_couple_baie, :source => :baie_one

  scope :sorted, -> {joins(:salle).order("salles.title asc", "baies.ilot asc", "baies.title asc")}

  def name_with_salle_and_ilot
    "#{salle.title.present? ? "Salle #{salle.title} " : ''} #{ilot.present? ? "Ilot #{ilot}" : ''} Baie #{title.present? ? title : 'non précisée' }"
  end

  def self.to_txt(servers_per_bay)
    txt = ""
    if servers_per_bay.present?
      servers_per_bay.each do |ilot, baies|
        baies.each_with_index do |(baie, serveurs), index|
          txt << "\r\n#{baie}\r\n"
          txt << "---------------\r\n"
          serveurs.each do |serveur|
            txt << "[#{serveur.position.to_s.rjust(2, "0")}] #{serveur.nom}\r\n"
          end
        end
      end
    end
    txt
  end

  def other_baie
    coupled_baie || inverse_coupled_baie
  end

  def has_no_coupled_baie?
    ([coupled_baie] | [inverse_coupled_baie]).compact.empty?
  end

end
