class InitConnectionsFromCurrentCardsConnectionIdentifier < ActiveRecord::Migration[5.0]
  def up

    # All cards with identifier (switchs / patch panels)
    cards = Card.where("connections_identifier IS NOT NULL AND connections_identifier <> ''")

    # todo Remove that !!! Just for tests
    # cards = cards.to_a.reject{|c|c.server_id != 721} .where(server_id: 721)

    cards.each do |card|

      card.composant.enclosure.display = 'horizontal'
      card.composant.enclosure.save

      if card.server.blank?
        puts "no server ? #{card.inspect}"
      end
      bay = card.server.bay
      # All ports connected to this card
      server_ports = Port.joins(:card => [:card_type, :server])
          .joins('INNER JOIN "port_types" ON "card_types"."port_type_id" = "port_types"."id" AND "port_types".name <> \'SAS\'')
          .joins('INNER JOIN "frames" ON "frames".id = "servers"."frame_id" AND "bay_id" = '+ bay.id.to_s)
          .includes(:card)
          .where('substring(cablename from \'.\') IN (?)', card.connections_identifier)
          .order('cablename asc')
          .to_a

      # TODO Complete script - create destination port

      puts "ports : #{server_ports.map(&:cablename).inspect}"
      puts "ports : #{server_ports.map(&:color).inspect}"
      puts "ports : #{server_ports.map(&:position).inspect}"

      card.create_missing_ports
      card.reload

      puts "card: #{card.inspect}"
      puts "card ports : #{card.ports.size}"

      card_ports = card.ports.sorted

      server_ports.reject!{|p| [2477, 2480, 2487, 2484].include?(p.id)} #V00 or T00 when 13 connections for 12 ports

      rectif_index = 0
      server_ports.each_with_index do |server_port, index|

        if([2412, 2297, 2409, 2351, 2407, 2350, 2296, 2414 ].include?(server_port.id)) # Duplicated V09 or T09
          rectif_index = 1
        else

          index = index - rectif_index if rectif_index

          card_port = card_ports[index]

          puts "(#{index}-#{card_port.position}-#{server_port.position})#{server_port.inspect}"

          if(card_port.nil?)
            puts "ALERT card_port nil at index #{index}"
          end

          if(server_port.nil?)
            puts "ALERT server_port nil (#{index})"
          end

          card_port.vlans = server_port.vlans
          card_port.connection = nil
          card_port.save

          # if card_port.connection
          #   card_port.connection.destroy
          # end

          Connection.find_or_create_by(port_id: card_port.id, cable_id: server_port.cable.id) if server_port.cable
        end



      end

      puts "saved ports : #{card_ports.map{|p|p.cable.try(:name)}.inspect}"
      puts "saved ports : #{card_ports.map{|p|p.cable.try(:color)}.inspect}"
      puts "saved ports : #{card_ports.map(&:position).inspect}"

    end

    # raise Exception

  end
  def down
  end
end
