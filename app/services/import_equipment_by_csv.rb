# frozen_string_literal: true

require 'csv'

class ImportEquipmentByCsv
  DEFAULT_NB_OF_SLOTS = 7

  def self.call(**args)
    new(**args).call
  end

  def initialize(file:, room_id:)
    @file = file
    @room_id = room_id
  end

  def call
    ApplicationRecord.transaction do
      new_frame = nil
      f = nil
      CSV.foreach(file.path, headers: true, col_sep: ';') do |row|
        data = row.to_hash
        if data.present?
          modele = Modele.find_by_name(data['Modele'])

          raise "Modèle inconnu - #{data["Modele"]}" if modele.blank?
          raise "Modèle incomplet : Pas d'enclosure - #{data["Modele"]}" if modele.enclosures.empty?
          raise "Les numéros de série doivent être présent" if data['Numero'].blank?

          server = Server.new
          f = Frame.find_by_name(data['Baie']) if data['Baie'].present?
          if data['Baie'].present? && f.present?
            server.frame = f
          else
            if new_frame.nil?
              islet = room.islets.first
              bay = islet.bays.create!(lane: 1,
                                       name: file.original_filename.sub('.csv', ''),
                                       bay_type_id: 1)
              new_frame = bay.frames.create!(name: bay.name)
            end
            server.frame = new_frame
          end

          server.position = data['Position'] if data['Position'].present?
          server.modele = modele
          server.name = data['Nom']
          server.numero = data['Numero']
          server.critique = (data['Critique'] == 'oui')
          server.cluster = Cluster.find_or_create_by!(name: data['Cluster'])
          server.domaine = Domaine.find_or_create_by!(name: data['Domaine'])
          server.comment = data['Comment'] if data['Comment'].present?
          init_slots(data, server)
          unless server.save
            raise "Erreur lors de l'ajout d'une machine - Les numéros de série doivent être uniques"
          end
        end
      end

      if new_frame
        new_frame.compact_u.save
        new_frame
      else
        f
      end
    end
  rescue StandardError => e
    e.message
  end

  private

  attr_reader :room_id, :file

  def room
    @room ||= Room.find(room_id)
  end

  def init_slots(data, server)
    enclosure = server.modele.enclosures.first

    DEFAULT_NB_OF_SLOTS.times do |i|
      Composant.find_or_create_by!(enclosure_id: enclosure.id,
                                   name: "SL#{i + 1}")
    end
    composant_slot_alim = Composant.find_or_create_by!(enclosure_id: enclosure.id,
                                                       name: "ALIM")
    composant_slot_cm = Composant.find_or_create_by!(enclosure_id: enclosure.id,
                                                     name: "CM")
    composant_slot_ipmi = Composant.find_or_create_by!(enclosure_id: enclosure.id,
                                                       name: "IPMI")

    # SLOTS SL
    slots = Composant.where(enclosure_id: enclosure.id)
    DEFAULT_NB_OF_SLOTS.times do |index|
      slot_name = "SL#{index + 1}"
      slot_data = data[slot_name]
      if slot_data.present?
        if slot_data[0].is_a?(Integer)
          valeur = slot_data[1..-1]
          nb_ports = slot_data[0].to_i
        else
          valeur = slot_data
          nb_ports = 1
        end
        port_type = PortType.find_or_create_by!(name: valeur)
        card_type = CardType.find_or_create_by!(name: slot_data, port_quantity: nb_ports, port_type: port_type)
        Card.find_or_create_by!(card_type: card_type, server: server, composant: slots.where("name = ?", slot_name).first)
      end
    end

    # SLOTS CM
    valeur = 'RJ'
    nb_ports = data['CM'].to_s.gsub(valeur, '').to_i
    port_type = PortType.find_or_create_by!(name: valeur)
    card_cm = CardType.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
    Card.find_or_create_by!(card_type: card_cm, server: server, composant: composant_slot_cm)

    # SLOTS IPMI
    valeur = 'RJ'
    nb_ports = data['IPMI'].to_s.gsub(valeur, '').to_i
    port_type = PortType.find_or_create_by!(name: valeur)
    card_ipmi = CardType.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
    Card.find_or_create_by!(card_type: card_ipmi, server: server, composant: composant_slot_ipmi)

    # SLOTS ALIM
    valeur = 'ALIM'
    nb_ports = data['Alim'].to_s.gsub(valeur, '').to_i
    port_type = PortType.find_or_create_by!(name: valeur)
    card_alim = CardType.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
    Card.find_or_create_by!(card_type: card_alim, server: server, composant: composant_slot_alim)
  end
end
