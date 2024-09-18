# frozen_string_literal: true

json.extract! @modele, :id, :name, :description, :color, :u, :nb_elts, :category, :architecture, :manufacturer

json.enclosures(@modele.enclosures) do |enclosure|
  json.extract! enclosure, :id, :display, :position, :grid_areas, :components
end

json.extract! @modele, :created_at, :updated_at
