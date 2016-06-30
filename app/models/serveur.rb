class Serveur < ActiveRecord::Base

  include PublicActivity::Model

  belongs_to :acte
  belongs_to :baie
  has_one :salle, through: :baie
  belongs_to :gestion
  belongs_to :domaine
  belongs_to :modele
  belongs_to :armoire
  belongs_to :localisation
  belongs_to :cluster

  has_many :slots
  has_many :cards_serveurs, -> { joins(:composant).order("composants.name asc, composants.position asc") }
  has_many :cards, through: :cards_serveurs

  accepts_nested_attributes_for :cards_serveurs,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  require 'csv'
  def self.import(csv_file)
    salle = Salle.find_or_create_by!(title: 'Atelier')
    baie = Baie.create!(title: csv_file.original_filename.sub('.csv', ''),
                        salle: salle)
    CSV.foreach(csv_file.path, {headers: true, col_sep: ';' }) do |row|
      server_data = row.to_hash
      modele = Modele.find_by_title(server_data['Modele'])
      raise "Modèle inconnu - #{server_data['Modele']}" if modele.blank?
      server = Serveur.new(baie: baie)
      server.modele = modele
      server.nom = server_data['Nom']
      server.critique = (server_data['Critique'] == 'oui')
      unless server.save
        raise "Problème lors de l'ajout par fichier CSV"
      end
    end
    return baie
  end

end
