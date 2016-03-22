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

=begin

Modele.delete_all
Serveur.delete_all
Slot.delete_all
Composant.delete_all

case ActiveRecord::Base.connection.adapter_name
  when 'SQLite'
    update_seq_sql = "update sqlite_sequence set seq = 0 where name = 'serveurs';"
    ActiveRecord::Base.connection.execute(update_seq_sql)
  when 'PostgreSQL'
    ActiveRecord::Base.connection.reset_pk_sequence!("modeles")
    ActiveRecord::Base.connection.reset_pk_sequence!("serveurs")
    ActiveRecord::Base.connection.reset_pk_sequence!("slots")
    ActiveRecord::Base.connection.reset_pk_sequence!("composants")
  else
    raise "Task not implemented for this DB adapter"
end
puts "Table Serveurs vide et pk_sequence = 0"

=end

file = File.read(Rails.root.join('lib', 'seeds', 'inventaire_160318.csv'))
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

  #########
  ## MODELE
  modele = Modele.find_or_create_by!(title: row[4],
                                    published: true,
                                    category: type,
                                    nb_elts: nb_elts,
                                    architecture: archi,
                                    u: u,
                                    marque: marque)

  type_composant_alim = TypeComposant.find_by_title('ALIM')
  nb_elts.to_i.times do
    Composant.find_or_create_by!(modele: modele,
                      type_composant: type_composant_alim
    )
  end unless modele.composants.to_a.reject!{|c| c.type_composant != type_composant_alim}.present?

  type_composant_cm = TypeComposant.find_by_title('CM')
  rj45_cm.to_i.times do
    Composant.find_or_create_by!(modele: modele,
                     type_composant: type_composant_cm
    )
  end unless modele.composants.to_a.reject!{|c| c.type_composant != type_composant_cm}.present?

  type_composant_ipmi = TypeComposant.find_by_title('IPMI')
  ipmi_futur.to_i.times do
    Composant.find_or_create_by!(modele: modele,
                     type_composant: type_composant_ipmi
    )
  end unless modele.composants.to_a.reject!{|c| c.type_composant != type_composant_ipmi}.present?

  type_composant_slot = TypeComposant.find_by_title('SLOT')
  7.times do
    Composant.find_or_create_by!(modele: modele,
                     type_composant: type_composant_slot
    )
  end unless modele.composants.to_a.reject!{|c| c.type_composant != type_composant_slot}.present?

  ##########
  ## SERVEUR
  serveur = Serveur.where(id: id).first
  unless serveur.present?
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

  slots = []
  7.times do |i|
    slots[i] = Composant.where(modele_id: modele.id, type_composant_id: type_composant_slot.id, position:i+1).first
  end

  valeurs_slots = []
  7.times do |i|
    valeurs_slots[i] = row[38+i]
  end

  class String
    def is_integer?
      self.to_i.to_s == self
    end
  end

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
      CardsServeur.find_or_create_by!(card: card, serveur: serveur, composant: slots[i])

      # ports ....
      nb_ports.times do |y|
        Slot.find_or_create_by!(valeur: valeur,
                     composant: slots[i],
                     serveur: serveur)
      end
    end
  end

end

# ActiveRecord::Base.connection.set_pk_sequence!("serveurs", 1000)
