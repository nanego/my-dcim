# frozen_string_literal: true

json.extract! @server, :id, :name, :modele, :numero, :cluster, :critique, :domaine, :gestion, :created_at, :updated_at

json.cards @server.cards do |card|
  json.extract! card, :id, :name, :first_position, :orientation, :card_type_id, :composant_id, :twin_card_id
  json.ports card.ports.order(:position), :id, :position, :vlans, :color, :cablename
end
