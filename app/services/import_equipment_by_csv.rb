require 'csv'

class ImportEquipmentByCSV

  DEFAULT_NB_OF_SLOTS = 7

  def self.call(*args)
      new(*args).call
  end

  def initialize(file:, room_id:, equipment_status_id:)
    @file = file
    @room_id = room_id
    @equipment_status_id = equipment_status_id
  end

  def call
    begin
      ApplicationRecord.transaction do
      islet = room.islets.first
      bay = islet.bays.create!(lane: 1,
                               name: file.original_filename.sub('.csv', ''),
                               bay_type_id: 1)
      frame = bay.frames.create!(name: bay.name)
        CSV.foreach(file.path, {headers: true, col_sep: ';' }) do |row|
          data = row.to_hash
          if data.present?
            modele = Modele.find_by_name(data['Modele'])
            raise "Modèle inconnu - #{data['Modele']}" if modele.blank?
            raise "Modèle incomplet : Pas d'enclosure - #{data['Modele']}" if modele.enclosures.empty?
            server = Server.new(frame: frame)
            server.server_state = equipment_status
            server.modele = modele
            server.name = data['Nom']
            server.numero = data['Numero']
            raise "Les numéros de série doivent être présent" if server.numero.blank?
            server.critique = (data['Critique'] == 'oui')
            server.cluster = Cluster.find_or_create_by!(name: data['Cluster'])
            server.domaine = Domaine.find_or_create_by!(name: data['Domaine'])
            init_slots(data, server)
            unless server.save
              raise "Erreur lors de l'ajout d'une machine - Les numéros de série doivent être uniques"
            end
          end
        end
        frame.compact_u.save
        return frame
      end
    rescue Exception => e
      return e.message
    end
  end

  private

    attr_reader :room_id, :file, :equipment_status_id

    def room
      @room ||= Room.find(room_id)
    end

    def equipment_status
      @equipment_status ||= ServerState.find_by_id(equipment_status_id)
    end

    def init_slots(data, server)
      enclosure = server.modele.enclosures.first

      type_composant_slot = TypeComposant.find_by_name('SLOT')
      DEFAULT_NB_OF_SLOTS.times do |i|
        Composant.find_or_create_by!(enclosure_id: enclosure.id,
                                     type_composant: type_composant_slot,
                                     name: "SL#{i+1}"
        )
      end
      composant_slot_alim = Composant.find_or_create_by!(enclosure_id: enclosure.id,
                                                         type_composant: type_composant_slot,
                                                         name: "ALIM")
      composant_slot_cm = Composant.find_or_create_by!(enclosure_id: enclosure.id,
                                                       type_composant: type_composant_slot,
                                                       name: "CM")
      composant_slot_ipmi = Composant.find_or_create_by!(enclosure_id: enclosure.id,
                                                         type_composant: type_composant_slot,
                                                         name: "IPMI")

      # SLOTS SL
      slots = Composant.where(enclosure_id: enclosure.id, type_composant_id: type_composant_slot.id)
      DEFAULT_NB_OF_SLOTS.times do |index|
        slot_name = "SL#{index+1}"
        slot_data = data[slot_name]
        if slot_data.present?
          if slot_data[0].is_integer?
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
