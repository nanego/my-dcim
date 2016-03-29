# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email


require 'open-uri'
require 'csv'

Composant.joins(:modele).where('title NOT LIKE ?', 'Panel').destroy_all




=begin

Modele.delete_all
Serveur.delete_all
Slot.delete_all
Composant.delete_all



case ActiveRecord::Base.connection.adapter_name
  when 'SQLite'
    #update_seq_sql = "update sqlite_sequence set seq = 0 where name = 'serveurs';"
    #ActiveRecord::Base.connection.execute(update_seq_sql)
  when 'PostgreSQL'
    #ActiveRecord::Base.connection.reset_pk_sequence!("modeles")
    #ActiveRecord::Base.connection.reset_pk_sequence!("serveurs")
    #ActiveRecord::Base.connection.reset_pk_sequence!("slots")
    # ActiveRecord::Base.connection.reset_pk_sequence!("composants")
  else
    raise "Task not implemented for this DB adapter"
end
puts "Table Composants vide et pk_sequence = 0"

=end

file = File.read(Rails.root.join('lib', 'seeds', 'inventaire_160326.csv'))
csv = CSV.parse(file, :headers => true)

ActiveRecord::Base.connection.set_pk_sequence!("serveurs", Serveur.maximum(:id)+1)

puts "Importation en cours"
csv.each_with_index do |row, i|
  # puts ((i/369).to_i).to_s+'%' if i % 50 == 0

  # Localisation,Rack,Nom du matériel,Type,Nb Elts,Architecture,U,MARQUE,MODELE,numéro de série,CONSO(Watt),I,PDUOndulé,PDUNormal,cluster,critique,domaine,gestion,Action,Phase,Salle,Îlot,"FCTotal","FCUtilisé","RJ45Total","RJ45Utilisé","RJ45Futur","IPMIUtilisé","IPMIFutur","RJ45CM","IPMIDédié",Slot 1,Slot 2,Slot 3,Slot 4,Slot 5,Slot 6,Slot 7,,,,,,

  id = row[0]
  localisation = Localisation.find_or_create_by(title: row[1], published: true)
  rack = Armoire.find_or_create_by(title: row[2], published: true)
  nom = row[3]
  type = Category.find_or_create_by(title: row[5], published: true)
  nb_elts = row[6]
  archi = Architecture.find_or_create_by(title: row[7], published: true)
  u = row[8]
  marque = Marque.find_or_create_by(title: row[9], published: true)
  numero = row[10]
  conso = row[11]
  i = row[12]
  pdu_ondule = row[13]
  pdu_normal = row[14]
  cluster = row[15].present? ? Cluster.find_or_create_by(title: row[15]) : nil
  critique = row[16].present?
  domaine = Domaine.find_or_create_by(title: row[17], published: true)
  gestion = Gestion.find_or_create_by(title: row[18], published: true)
  action = Acte.find_or_create_by(title: row[19], published: true)
  phase = row[20]
  salle = Salle.find_or_create_by(title: row[21], published: true)
  ilot = row[22]
  baie = Baie.find_or_create_by(title: row[23], salle: salle, ilot: ilot)
  # id_baie = row[24]
  fc_total = row[25]
  fc_calcule  = row[26]
  fc_utilise  = row[27]
  fc_futur  = row[28]
  rj45_total = row[29]
  rj45_calcule = row[30]
  rj45_utilise = row[31]
  rj45_futur = row[32]
  tenGbps_futur = row[33]
  rj45_cm = row[34]
  ipmi_dedie = row[35]
  ipmi_utilise = row[36]
  ipmi_futur = row[37]

  ip = row[52]
  hostname = row[53]
  etat_conf_reseau = row[54]
  action_conf_reseau = row[55]

  ipmi_futur_bis = row[56]
  rj_futur_bis = row[57]
  rj_a_brancher = row[58]
  couleur_cable = row[59]
  confswitch = row[60]
  noms_cables = row[61]

  puts noms_cables


  #########
  ## MODELE
  modele = Modele.find_or_create_by!(title: row[4],
                                    published: true,
                                    category: type,
                                    nb_elts: nb_elts,
                                    architecture: archi,
                                    u: u,
                                    marque: marque)

  type_composant_slot = TypeComposant.find_by_title('SLOT')

  7.times do |i|
    composant_slot = Composant.find_or_create_by!(modele: modele,
                                                  type_composant: type_composant_slot,
                                                  name: "SL#{i+1}"
    )
  end

  type_composant_alim = TypeComposant.find_by_title('ALIM')
  nb_elts.to_i.times do |i|
    Composant.find_or_create_by!(modele: modele,
                                 type_composant: type_composant_alim,
                                 position: i+1
    )
  end
  composant_slot_alim = Composant.find_or_create_by!(modele: modele,
                                                type_composant: type_composant_slot,
                                                name: "ALIM")


  type_composant_cm = TypeComposant.find_by_title('CM')
  rj45_cm.to_i.times do |i|
    Composant.find_or_create_by!(modele: modele,
                                 type_composant: type_composant_cm,
                                 position: i+1
    )
  end
  composant_slot_cm = Composant.find_or_create_by!(modele: modele,
                                                     type_composant: type_composant_slot,
                                                     name: "CM"
  )

  type_composant_ipmi = TypeComposant.find_by_title('IPMI')
  ipmi_futur.to_i.times do |i|
    Composant.find_or_create_by!(modele: modele,
                                 type_composant: type_composant_ipmi,
                                 position: i+1
    )
  end
  composant_slot_ipmi = Composant.find_or_create_by!(modele: modele,
                                                   type_composant: type_composant_slot,
                                                   name: "IPMI"
  )


  ##########
  ## SERVEUR
  serveur = Serveur.where(id: id).first
  if serveur.present?
    serveur.update_attributes(
=begin
        ip: ip,
        hostname: hostname,
        etat_conf_reseau: etat_conf_reseau,
        action_conf_reseau: action_conf_reseau,
        tenGbps_futur: tenGbps_futur,
        rj45_calcule: rj45_calcule,
        rj45_total: rj45_total,
        fc_futur: fc_futur,
        fc_calcule: fc_calcule,
        baie: baie,
        pdu_ondule: pdu_ondule,
        pdu_normal: pdu_normal,
        localisation: localisation,
        armoire: rack,
        nom: nom,
        modele: modele,
        numero: numero,
        conso: conso,
        cluster: cluster,
        critique: critique,
        domaine: domaine,
        gestion: gestion,
        acte: action,
=end
        phase: phase
=begin
        salle: salle,
        ilot: ilot,
        fc_total: fc_total,
        fc_utilise: fc_utilise,
        rj45_utilise: rj45_utilise,
        rj45_futur: rj45_futur,
        rj45_cm: rj45_cm,
        ipmi_dedie: ipmi_dedie,
        ipmi_futur: ipmi_futur,
        ipmi_utilise: ipmi_utilise
=end
    )
  else
    serveur = Serveur.create!(
        id: id,
        ip: ip,
        hostname: hostname,
        etat_conf_reseau: etat_conf_reseau,
        action_conf_reseau: action_conf_reseau,
        tenGbps_futur: tenGbps_futur,
        rj45_calcule: rj45_calcule,
        rj45_total: rj45_total,
        fc_futur: fc_futur,
        fc_calcule: fc_calcule,
        baie: baie,
        pdu_ondule: pdu_ondule,
        pdu_normal: pdu_normal,
        localisation: localisation,
        armoire: rack,
        nom: nom,
        modele: modele,
        numero: numero,
        conso: conso,
        cluster: cluster,
        critique: critique,
        domaine: domaine,
        gestion: gestion,
        acte: action,
        phase: phase,
        salle: salle,
        ilot: ilot,
        fc_total: fc_total,
        fc_utilise: fc_utilise,
        rj45_utilise: rj45_utilise,
        rj45_futur: rj45_futur,
        rj45_cm: rj45_cm,
        ipmi_dedie: ipmi_dedie,
        ipmi_futur: ipmi_futur,
        ipmi_utilise: ipmi_utilise
    )
  end

  ########
  ## SLOTS

  slots = Composant.where(modele_id: modele.id, type_composant_id: type_composant_slot.id).order("name asc, position asc")
  slots_SL_only = slots.where("name LIKE 'SL%'").to_a
  valeurs_slots = []
  7.times do |i|
    valeurs_slots[i] = row[38+i]
  end

  class String
    def is_integer?
      self.to_i.to_s == self
    end
  end

  # SLOTS SL
  7.times do |i|
    if valeurs_slots[i].present?
      if valeurs_slots[i][0].is_integer?
        valeur = valeurs_slots[i][1..-1]
        nb_ports = valeurs_slots[i][0].to_i
      else
        valeur = valeurs_slots[i]
        nb_ports = 1
      end
      port_type = PortType.find_or_create_by!(name: valeur)
      card = Card.find_or_create_by!(name: valeurs_slots[i], port_quantity: nb_ports, port_type: port_type)
      CardsServeur.find_or_create_by!(card: card, serveur: serveur, composant: slots_SL_only[i])

      # ports ....
      nb_ports.times do |y|
        Slot.find_or_create_by!(valeur: valeur,
                     composant: slots_SL_only[i],
                     serveur: serveur)
      end
    end
  end

  # SLOTS CM
  valeur = 'RJ'
  nb_ports = rj45_cm.to_i
  port_type = PortType.find_or_create_by!(name: valeur)
  card_cm = Card.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
  CardsServeur.find_or_create_by!(card: card_cm, serveur: serveur, composant: composant_slot_cm)

  # SLOTS IPMI
  valeur = 'RJ'
  nb_ports = ipmi_futur.to_i
  port_type = PortType.find_or_create_by!(name: valeur)
  card_ipmi = Card.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
  CardsServeur.find_or_create_by!(card: card_ipmi, serveur: serveur, composant: composant_slot_ipmi)

  # SLOTS ALIM
  valeur = 'ALIM'
  nb_ports = nb_elts.to_i
  port_type = PortType.find_or_create_by!(name: valeur)
  card_alim = Card.find_or_create_by!(name: "#{nb_ports}#{valeur}", port_quantity: nb_ports, port_type: port_type)
  CardsServeur.find_or_create_by!(card: card_alim, serveur: serveur, composant: composant_slot_alim)


  # Init confs vlans and colors
  rjs_a_brancher = rj_a_brancher.split(';') if rj_a_brancher.present?
  couleurs = couleur_cable.split(';')  if couleur_cable.present?
  confs = confswitch.split(';') if confswitch.present?
  nomscables = noms_cables.split(';') if noms_cables.present?


  rjs_a_brancher.each_with_index do |type_port, index|
    type_port = type_port.gsub(/[[:space:]]+/, "")

    case type_port
      when 'ipmi'
        cards_serveurs = CardsServeur.find_or_create_by!(card: card_ipmi, serveur: serveur, composant: composant_slot_ipmi)
        port = Port.find_or_create_by!(position: 1,
                                       parent_type: CardsServeur.name,
                                       parent_id: cards_serveurs.id,
                                       vlans: confs ? confs[index] : nil,
                                       color: couleurs ? couleurs[index] : nil,
                                       cablename: nomscables ? nomscables[index] : nil
        )
      when /^cm/
        cards_serveurs = CardsServeur.find_or_create_by!(card: card_cm, serveur: serveur, composant: composant_slot_cm)
        port = Port.find_or_create_by!(position: type_port[2],
                                       parent_type: CardsServeur.name,
                                       parent_id: cards_serveurs.id,
                                       vlans: confs ? confs[index] : nil,
                                       color: couleurs ? couleurs[index] : nil,
                                       cablename: nomscables ? nomscables[index] : nil
        )
      when /^slot/
        position_slot = type_port[4]
        position_port_in_slot = type_port[6]
        composant = Composant.find_or_create_by!(modele: modele,
                                                 type_composant: type_composant_slot,
                                                 name: 'SL'+position_slot
        )
        cards_serveurs = CardsServeur.find_or_create_by!(serveur: serveur, composant: composant)
        port = Port.find_or_create_by!(position: position_port_in_slot,
                                       parent_type: CardsServeur.name,
                                       parent_id: cards_serveurs.id,
                                       vlans: confs ? confs[index] : nil,
                                       color: couleurs ? couleurs[index] : nil,
                                       cablename: nomscables ? nomscables[index] : nil
        )
    end

  end if rjs_a_brancher.present?

end

# ActiveRecord::Base.connection.set_pk_sequence!("serveurs", 1000)
