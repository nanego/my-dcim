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
      if request.format.to_sym == :pdf
        value
      else
        link_to value, model
      end
    end
  end
  column(:localisation, :order => proc { |scope|
    scope.joins(:localisation).order("localisations.title")
  }) do |record|
    record.localisation
  end
  column(:rack, :order => proc { |scope|
    scope.joins(:armoire).order("armoires.title")
  }) do |record|
    record.armoire
  end
  column(:nom) do |model|
    format(model.nom) do |value|
      if request.format.to_sym == :pdf
        value
      else
        link_to value, model
      end
    end
  end
  column(:type, :order => proc { |scope|
    scope.joins(:categorie).order("categories.title")
  }) do |record|
    record.categorie
  end
  column(:nb_elts)
  column(:architecture, :order => proc { |scope|
    scope.joins(:architecture).order("architectures.title")
  }) do |record|
    record.architecture
  end
  column(:u)
  column(:marque, :order => proc { |scope|
    scope.joins(:marque).order("marques.title")
  }) do |record|
    record.marque
  end
  column(:modele, :order => proc { |scope|
    scope.joins(:modele).order("modeles.title")
  }) do |record|
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
  column(:domaine, :order => proc { |scope|
    scope.joins(:domaine).order("domaines.title")
  }) do |record|
    record.domaine
  end
  column(:gestionnaire, :order => proc { |scope|
    scope.joins(:gestion).order("gestions.title")
  }) do |record|
    record.gestion
  end
  column("Action à réaliser", :order => proc { |scope|
    scope.joins(:acte).order("actes.title")
  }) do |record|
    record.acte
  end
  column(:phase)
  column(:salle, :order => proc { |scope|
    scope.joins(:salle).order("salles.title")
  }) do |record|
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

  column(:pdu_ondule)
  column(:pdu_normal)
  column(:baie)
  column(:id_baie)
  column(:fc_calcule)
  column(:fc_futur)
  column(:i)
  column(:rj45_calcule)
  column(:tenGbps_futur)
  column(:ip)
  column(:hostname)
  column(:etat_conf_reseau)
  column(:action_conf_reseau)

  column(:slots, :html => true, :mandatory => false) do |r|
    if r.slots.map(&:valeur).reject!{|v| v.blank?}.present?
      r.slots.map{ |slot| slot.valeur.present? ? slot.valeur : "" }
      table = "<table BORDER='1' style='text-align: center;'><tr style=\"background-color:#DDDDDD \">"
      r.slots.each do |s|
        table << "<td style=\"min-width:27px;\">#{s.numero}</td>"
      end
      table << "</tr><tr>"
      r.slots.each do |s|
        table << "<td>#{s.valeur}</td>"
      end
      table << "</tr></table>"
      table.html_safe
    end
  end

  column("Boutons", :html => true, :mandatory => false) do |record|
    link_to('Modifier', edit_serveur_path(record)).to_s + '<span style="margin-left:10px">'.html_safe + link_to('Supprimer', record, method: :delete, data: { confirm: 'Are you sure?' }).to_s + '</span>'.html_safe
  end

end
