class ServeursGrid

  include Datagrid

  #########
  # Scope
  #########

  scope do
    Serveur
  end

  #########
  # Filters
  #########

  filter(:id, :string, :multiple => ',')
  filter(:localisation, :enum, :select => Localisation.where(published: true).map {|r| [r.to_s, r.id]})
  filter :armoire, :enum, :select => Armoire.where(published: true).map {|r| [r.to_s, r.id]}
  filter :nom do |value|
    where("nom LIKE ?", value)
  end
  filter(:categorie, :enum, :select => Categorie.where(published: true).map {|r| [r.to_s, r.id]})
  filter :nb_elts, :integer, :range => true #, :default => proc { [Serveur.minimum(:nb_elts), Serveur.maximum(:nb_elts)] }
  filter(:architecture, :enum, :select => Architecture.where(published: true).map {|r| [r.to_s, r.id]})
  filter :u, :integer, :range => true #, :default => proc { [Serveur.minimum(:u), Serveur.maximum(:u)] }
  filter(:marque, :enum, :select => Marque.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:modele, :enum, :select => Modele.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:numero, :string)
  filter :conso, :integer, :range => true #, :default => proc { [Serveur.minimum(:conso), Serveur.maximum(:conso)] }
  filter(:cluster, :xboolean)
  filter(:critique, :xboolean)
  filter(:domaine, :enum, :select => Domaine.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:gestion, :enum, :select => Gestion.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:acte, :enum, :select => Acte.where(published: true).map {|r| [r.to_s, r.id]})
  filter :phase, :integer, :range => true #, :default => proc { [Serveur.minimum(:phase), Serveur.maximum(:phase)] }
  filter(:salle, :enum, :select => Salle.where(published: true).map {|r| [r.to_s, r.id]})
  filter :ilot, :integer, :range => true #, :default => proc { [Serveur.minimum(:ilot), Serveur.maximum(:ilot)] }
  filter :fc_total, :integer, :range => true
  filter :fc_utilise, :integer, :range => true
  filter :rj45_total, :integer, :range => true
  filter :rj45_utilise, :integer, :range => true
  filter :rj45_futur, :integer, :range => true
  filter :ipmi_utilise, :integer, :range => true
  filter :ipmi_futur, :integer, :range => true
  filter :rj45_cm, :integer, :range => true
  filter :ipmi_dedie, :integer, :range => true

  filter(:condition, :dynamic, :header => "Condition dynamique")

  column_names_filter(:header => "Colonnes à afficher :", checkboxes: true)


  #########
  # Columns
  #########

  column(:id) do |model|
    format(model.id) do |value|
      link_to value, model
    end
  end
  column(:localisation) do |record|
    record.localisation
  end
  column(:rack) do |record|
    record.armoire
  end
  column(:nom) do |model|
    format(model.nom) do |value|
      link_to value, model
    end
  end
  column(:type) do |record|
    record.categorie
  end
  column(:nb_elts)
  column(:architecture) do |record|
    record.architecture
  end
  column(:u)
  column(:marque) do |record|
    record.marque
  end
  column(:modele) do |record|
    record.modele
  end
  column(:numero)
  column(:conso)
  column(:critique, :mandatory => false) do
    critique ? "Oui" : "Non"
  end
  column(:cluster, :mandatory => false) do
    cluster ? "Oui" : "Non"
  end
  column(:domaine) do |record|
    record.domaine
  end
  column(:gestionnaire) do |record|
    record.gestion
  end
  column("Action à réaliser") do |record|
    record.acte
  end
  column(:phase)
  column(:salle) do |record|
    record.salle
  end
  column(:ilot)
  column(:fc_total)
  column(:fc_utilise)
  column(:rj45_total)
  column(:rj45_utilise)
  column(:rj45_futur)
  column(:ipmi_utilise)
  column(:ipmi_futur)
  column(:rj45_cm)
  column(:ipmi_dedie)

  column(:slots, :html => true, :mandatory => false) do |r|
    r.slots.map{ |slot| slot.valeur.present? ? slot.valeur : "" }
    table = "<table BORDER='1' style='text-align: center;'><tr>"
    r.slots.each do |s|
      table << "<td>#{s.numero}</td>"
    end
    table << "</tr><tr>"
    r.slots.each do |s|
      table << "<td>#{s.valeur}</td>"
    end
    table << "</tr></table>"
    table.html_safe
  end

  column("Boutons", :html => true, :mandatory => false) do |record|
    link_to('Modifier', edit_serveur_path(record)).to_s + '<span style="margin-left:10px">'.html_safe + link_to('Supprimer', record, method: :delete, data: { confirm: 'Are you sure?' }).to_s + '</span>'.html_safe
  end

end
