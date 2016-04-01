class Baie < ActiveRecord::Base

  has_many :serveurs
  belongs_to :salle

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
            txt << "[#{serveur.position}] #{serveur.nom}\r\n"
          end
        end
      end
    end
    txt
  end

end
