class Baie < ActiveRecord::Base

  has_many :serveurs
  belongs_to :salle

  def name_with_salle_and_ilot
    "#{salle.title.present? ? "Salle #{salle.title} " : ''} #{ilot.present? ? "Ilot #{ilot}" : ''} Baie #{title.present? ? title : 'non précisée' }"
  end

end
