# frozen_string_literal: true

class MovedConnectionDecorator < ApplicationDecorator
  def description
    "Connexion entre #{port_from.server.try(:modele).try(:category)} #{port_from.server} (port ##{port_from_id}) et " \
      "#{port_to.try(:server).try(:modele).try(:category)} #{port_to.try(:server)} (port ##{port_to_id}) => vlans:#{vlans} " \
      "cablename:#{cablename} couleur:#{color}"
  end
end
