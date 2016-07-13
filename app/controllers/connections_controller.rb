class ConnectionsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create

    cards = {}
    ports = {}
    ['from', 'to'].each do |destination|

      server = Serveur.find_by_id(params[destination]['server_id'])

      if params[destination]['composant_type'] == CardsServeur.name
        cards[destination] = CardsServeur.find(params[destination]['composant_id'])
      else
        cards[destination] = CardsServeur.find_or_create_by!(card_id: nil,
                                                             serveur_id: params[destination]['server_id'],
                                                             composant_id: server.modele.composants.joins(:type_composant).where('type_composants.title = ? AND composants.position = ?', params[destination]['composant_type'], params[destination]['port_position']).first.id )
      end
      ports[destination] = Port.find_or_create_by!(parent_id: cards[destination].id,
                                     parent_type: cards[destination].class.name,
                                     position: params[destination]['port_position']
      )
    end

    connections = Connection.where("(source_port_id = ? AND destination_port_id = ?) OR (source_port_id = ? AND destination_port_id = ?)", ports['from'], ports['to'], ports['to'], ports['from'])
    if connections.empty?
      Connection.find_or_create_by!(source_port_id: ports['from'].id, destination_port_id: ports['to'].id)
    end

  end

end
