class ServersGrid

  include Datagrid

  #########
  # Scope
  #########

  scope do
    Server.includes(:modele => :category, :frame => {:bay => {:islet => :room}})
  end

  #########
  # Filters
  #########

  filter(:id, :string, :multiple => ',')
  filter :nom do |value|
    where("nom LIKE ?", value)
  end
  filter 'Catégorie', :enum, :select => Category.where(published: true).map {|r| [r.to_s, r.id]}  do |value|
    joins(:modele).where("modeles.category_id = ?", value)
  end
  filter :nb_elts, :integer do |value|
    joins(:modele).where("modeles.nb_elts = ?", value)
  end
  filter :architecture, :enum, :select => Architecture.where(published: true).map {|r| [r.to_s, r.id]} do |value|
    joins(:modele).where("modeles.architecture_id = ?", value)
  end
  filter :u, :integer do |value|
    joins(:modele).where("modeles.u = ?", value)
  end
  filter :marque, :enum, :select => Marque.where(published: true).map {|r| [r.to_s, r.id]} do |value|
    joins(:modele).where("modeles.marque_id = ?", value)
  end
  filter(:modele, :enum, :select => Modele.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:numero, :string)
  filter(:position, :integer)
  filter :conso, :integer, :range => true #, :default => proc { [Server.minimum(:conso), Server.maximum(:conso)] }
  filter(:cluster, :enum, :select => Cluster.all.map {|r| [r.to_s, r.id]})
  filter(:critique, :xboolean)
  filter(:domaine, :enum, :select => Domaine.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:gestion, :enum, :select => Gestion.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:acte, :enum, :select => Acte.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:frame, :enum, :select => Frame.all.map {|b| [b.name_with_room_and_islet, b.id]})
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
    scope.joins(:modele => :category).order("categories.title")
  }) do |record|
    record.modele.try(:category)
  end
  column(:nb_elts, :order => proc { |scope|
    scope.joins(:modele).order("nb_elts")
  }) do |record|
    record.modele.try(:nb_elts)
  end
  column(:architecture, :order => proc { |scope|
    scope.joins(:modele => :architecture).order("architectures.title")
  }) do |record|
    record.modele.try(:architecture)
  end
  column(:u, :order => proc { |scope|
    scope.joins(:modele).order("u")
  }) do |record|
    record.modele.try(:u)
  end
  column(:marque, :order => proc { |scope|
    scope.joins(:modele => :marque).order("marques.title")
  }) do |record|
    record.modele.try(:marque)
  end
  column(:modele, :order => proc { |scope|
    scope.joins(:modele).order("modeles.title")
  }) do |record|
    record.modele
  end
  column(:numero)
  column(:position)
  column(:conso)
  column(:critique, :mandatory => false) do
    critique ? "Oui" : "Non"
  end
  column(:cluster, :order => proc { |scope|
    scope.joins(:cluster).order("clusters.title")
  }) do |record|
    record.cluster
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
  column(:frame, :order => proc { |scope|
    scope.joins(:frames).order("frames.title")
  }) do |record|
    record.frame.try(:name_with_room_and_islet)
  end
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
    if r.slots.map(&:valeur).reject{|v| v.blank?}.present?
      table = "<table BORDER='1' style='text-align: center;'><tr style=\"background-color:#DDDDDD \">"
      r.modele.composants.where(type_composant_id: 4).each do |composant_slot|
        table << "<th style=\"min-width:27px;\">Slot #{composant_slot.position}</th>"
      end
      table << "</tr>"
      4.times do |i|
        slots_sur_modele = r.modele.composants.where(type_composant_id: 4)
        ports_utilises = r.slots.where(composant: slots_sur_modele, position: i+1)
        if ports_utilises.present?
          table << "<tr>"
          slots_sur_modele.each do |composant_slot|
            table << "<td>"
            ports_utilises.each do |s|
              table << "#{s.valeur}" if s.composant == composant_slot
            end
            table << "</td>"
          end
          table << "</tr>"
        end
      end
      table << "</table>"
      table.html_safe
    end
  end

  column("Boutons", :html => true, :mandatory => false) do |record|
    link_to('Modifier', edit_server_path(record)).to_s + '<span style="margin-left:10px">'.html_safe + link_to('Supprimer', record, method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-warning').to_s + '</span>'.html_safe
  end

end
