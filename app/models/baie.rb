class Baie < ActiveRecord::Base

  has_many :serveurs
  belongs_to :salle

  scope :sorted, -> {joins(:salle).order("salles.title asc", "baies.ilot asc", "baies.title asc")}

  def name_with_salle_and_ilot
    "#{salle.title.present? ? "Salle #{salle.title} " : ''} #{ilot.present? ? "Ilot #{ilot}" : ''} Baie #{title.present? ? title : 'non précisée' }"
  end

end
