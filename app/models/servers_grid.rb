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
  filter :name do |value|
    where("servers.name LIKE ?", value)
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
  filter :manufacturer, :enum, :select => Manufacturer.where(published: true).map {|r| [r.to_s, r.id]} do |value|
    joins(:modele).where("modeles.manufacturer_id = ?", value)
  end
  filter(:modele, :enum, :select => Modele.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:numero, :string)
  filter(:position, :integer)
  filter :conso, :integer, :range => true #, :default => proc { [Server.minimum(:conso), Server.maximum(:conso)] }
  filter(:cluster, :enum, :select => Cluster.all.map {|r| [r.to_s, r.id]})
  filter(:critique, :xboolean)
  filter(:domaine, :enum, :select => Domaine.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:gestion, :enum, :select => Gestion.where(published: true).map {|r| [r.to_s, r.id]})
  filter(:frame, :enum, :select => Frame.all.map {|b| [b.name_with_room_and_islet, b.id]})

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
  column(:name) do |model|
    format(model.name) do |value|
      if request.format.to_sym == :pdf
        value
      else
        link_to value, model
      end
    end
  end
  column(:type, :order => proc { |scope|
    scope.joins(:modele => :category).order("categories.name")
  }) do |record|
    record.modele.try(:category)
  end
  column(:nb_elts, :order => proc { |scope|
    scope.joins(:modele).order("nb_elts")
  }) do |record|
    record.modele.try(:nb_elts)
  end
  column(:architecture, :order => proc { |scope|
    scope.joins(:modele => :architecture).order("architectures.name")
  }) do |record|
    record.modele.try(:architecture)
  end
  column(:u, :order => proc { |scope|
    scope.joins(:modele).order("u")
  }) do |record|
    record.modele.try(:u)
  end
  column(:manufacturer, :order => proc { |scope|
    scope.joins(:modele => :manufacturer).order("manufacturers.name")
  }) do |record|
    record.modele.try(:manufacturer)
  end
  column(:modele, :order => proc { |scope|
    scope.joins(:modele).order("modeles.name")
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
    scope.joins(:cluster).order("clusters.name")
  }) do |record|
    record.cluster
  end
  column(:domaine, :order => proc { |scope|
    scope.joins(:domaine).order("domaines.name")
  }) do |record|
    record.domaine
  end
  column(:gestionnaire, :order => proc { |scope|
    scope.joins(:gestion).order("gestions.name")
  }) do |record|
    record.gestion
  end
  column(:frame, :order => proc { |scope|
    scope.joins(:frames).order("frames.name")
  }) do |record|
    record.frame.try(:name_with_room_and_islet)
  end

  column(:tenGbps_futur)
  column(:ip)
  column(:hostname)
  column(:etat_conf_reseau)
  column(:action_conf_reseau)

  column("Boutons", :html => true, :mandatory => false) do |record|
    link_to('Modifier', edit_server_path(record.id)).to_s + '<span style="margin-left:10px">'.html_safe + link_to('Supprimer', server_path(record.id), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-warning').to_s + '</span>'.html_safe
  end

end
