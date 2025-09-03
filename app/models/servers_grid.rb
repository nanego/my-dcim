# frozen_string_literal: true

class ServersGrid
  include Datagrid

  #########
  # Scope
  #########

  scope do
    Server.includes(modele: :category, frame: { bay: { islet: :room } })
  end

  #########
  # Filters
  #########

  filter :id, :string, multiple: ","
  filter :name do |value|
    where("LOWER(servers.name) LIKE ?", "%#{value.downcase}%")
  end
  filter :serial_number do |value|
    where("LOWER(servers.numero) LIKE ?", "%#{value.downcase}%")
  end
  filter "Catégorie", :enum, multiple: true, select: Category.sorted.map { |r| [r.to_s, r.id] } do |value|
    joins(:modele).where(modeles: { category_id: value })
  end
  filter :nb_elts, :integer do |value|
    joins(:modele).where(modeles: { nb_elts: value })
  end
  filter :architecture, :enum, multiple: true, checkboxes: true, select: Architecture.sorted.map { |r| [r.to_s, r.id] } do |value|
    joins(:modele).where(modeles: { architecture_id: value })
  end
  filter :u, :integer do |value|
    joins(:modele).where(modeles: { u: value })
  end
  filter :manufacturer, :enum, multiple: true, select: Manufacturer.sorted.map { |r| [r.to_s, r.id] } do |value|
    joins(:modele).where(modeles: { manufacturer_id: value })
  end
  filter(:modele, :enum, multiple: true, select: Modele.all_sorted.map { |r| [r.name_with_brand, r.id] })
  filter(:position, :integer)
  filter(:cluster, :enum, multiple: true, select: Cluster.sorted.map { |r| [r.to_s, r.id] })
  filter(:critique, :xboolean)
  filter(:domaine, :enum, multiple: true, select: Domaine.sorted.map { |r| [r.to_s, r.id] })
  filter(:gestion, :enum, multiple: true, select: Gestion.sorted.map { |r| [r.to_s, r.id] })
  filter(:frame, :enum, multiple: true, select: Frame.all_sorted.map { |b| [b.name_with_room_and_islet, b.id] })

  filter(:condition, :dynamic, header: "Condition dynamique")

  column_names_filter(header: "Colonnes affichées :", checkboxes: true)

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
  column(:type, order: proc { |scope|
    scope.joins(modele: :category).order("categories.name")
  }) do |record|
    record.modele.try(:category)
  end
  column(:nb_elts, order: proc { |scope|
    scope.joins(:modele).order(:nb_elts)
  }) do |record|
    record.modele.try(:nb_elts)
  end
  column(:architecture, order: proc { |scope|
    scope.joins(modele: :architecture).order("architectures.name")
  }) do |record|
    record.modele.try(:architecture)
  end
  column(:u, order: proc { |scope|
    scope.joins(:modele).order(:u)
  }) do |record|
    record.modele.try(:u)
  end
  column(:manufacturer, order: proc { |scope|
    scope.joins(modele: :manufacturer).order("manufacturers.name")
  }) do |record|
    record.modele.try(:manufacturer)
  end
  column(:modele, order: proc { |scope|
    scope.joins(:modele).order("modeles.name")
  }, &:modele)
  column("S/N", order: proc { |scope|
    scope.order(:numero)
  }, &:numero)
  column(:position)
  column(:critique, mandatory: false) do
    critique ? "Oui" : "Non"
  end
  column(:cluster, order: proc { |scope|
    scope.joins(:cluster).order("clusters.name")
  }, &:cluster)
  column(:domaine, order: proc { |scope|
    scope.joins(:domaine).order("domaines.name")
  }, &:domaine)
  column(:gestionnaire, order: proc { |scope|
    scope.joins(:gestion).order("gestions.name")
  }, &:gestion)
  column(:frame, order: proc { |scope|
    scope.joins(:frame).order("frames.name")
  }) do |record|
    record.frame.try(:name_with_room_and_islet)
  end

  column(:stack)
  # column(:network)

  column("Actions", html: true, mandatory: false) do |record|
    link_to(t("action.edit"), edit_server_path(record.slug), class: "btn btn-primary").to_s + '<span style="margin-left:10px">'.html_safe + link_to("Supprimer", server_path(record.slug), method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-danger").to_s + "</span>".html_safe
  end
end
