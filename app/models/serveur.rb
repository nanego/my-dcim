class Serveur < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

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
  belongs_to :server_state

  has_many :slots
  has_many :cards_serveurs, -> { joins(:composant).order("composants.name asc, composants.position asc") }
  has_many :cards, through: :cards_serveurs

  accepts_nested_attributes_for :cards_serveurs,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  def to_s
    nom
  end

  require 'csv'
  def self.import(csv_file, salle, server_state)
    salle = salle || Salle.find_or_create_by!(title: 'Atelier')
    baie = Baie.create!(title: csv_file.original_filename.sub('.csv', ''),
                        salle: salle)
    CSV.foreach(csv_file.path, {headers: true, col_sep: ';' }) do |row|
      server_data = row.to_hash
      modele = Modele.find_by_title(server_data['Modele'])
      raise "Modèle inconnu - #{server_data['Modele']}" if modele.blank?
      server = Serveur.new(baie: baie)
      server.server_state = server_state
      server.modele = modele
      server.nom = server_data['Nom']
      server.critique = (server_data['Critique'] == 'oui')
      server.cluster = Cluster.find_or_create_by!(title: server_data['Cluster'])
      server.domaine = Domaine.find_or_create_by!(title: server_data['Domaine'])
      unless server.save
        raise "Problème lors de l'ajout par fichier CSV"
      end
    end
    return baie
  end

  private

    def slug_candidates
      [
          :nom,
          [:nom, :id]
      ]
    end

end
