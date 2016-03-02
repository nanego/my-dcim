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

file = File.read(Rails.root.join('lib', 'seeds', 'inventaire_160216.csv'))
csv = CSV.parse(file, :headers => true)

puts "Importation en cours"
csv.each_with_index do |row, i|
  # puts ((i/369).to_i).to_s+'%' if i % 50 == 0

  # Localisation,Rack,Nom du matériel,Type,Nb Elts,Architecture,U,MARQUE,MODELE,numéro de série,CONSO(Watt),I,PDUOndulé,PDUNormal,cluster,critique,domaine,gestion,Action,Phase,Salle,Îlot,"FCTotal","FCUtilisé","RJ45Total","RJ45Utilisé","RJ45Futur","IPMIUtilisé","IPMIFutur","RJ45CM","IPMIDédié",Slot 1,Slot 2,Slot 3,Slot 4,Slot 5,Slot 6,Slot 7,,,,,,

  id = row[0]
  localisation = Localisation.find_or_create_by(title: row[1], published: true)
  rack = Armoire.find_or_create_by(title: row[2], published: true)
  nom = row[3]
  type = Categorie.find_or_create_by(title: row[4], published: true)
  nb_elts = row[5]
  archi = Architecture.find_or_create_by(title: row[6], published: true)
  u = row[7]
  marque = Marque.find_or_create_by(title: row[8], published: true)

  numero = row[10]
  conso = row[11]
  i = row[12]
  pdu_ondule = row[13]
  pdu_normal = row[14]
  cluster = row[15].present?
  critique = row[16].present?
  domaine = Domaine.find_or_create_by(title: row[17], published: true)
  gestion = Gestion.find_or_create_by(title: row[18], published: true)
  action = Acte.find_or_create_by(title: row[19], published: true)
  phase = row[20]
  salle = Salle.find_or_create_by(title: row[21], published: true)
  ilot = row[22]
  baie = row[23]
  id_baie = row[24]
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

=begin
  slot1 = Slot.create!(numero: 1, valeur: row[38])
  slot2 = Slot.create!(numero: 2, valeur: row[39])
  slot3 = Slot.create!(numero: 3, valeur: row[40])
  slot4 = Slot.create!(numero: 4, valeur: row[41])
  slot5 = Slot.create!(numero: 5, valeur: row[42])
  slot6 = Slot.create!(numero: 6, valeur: row[43])
  slot7 = Slot.create!(numero: 7, valeur: row[44])
=end

  ip = row[52]
  hostname = row[53]
  etat_conf_reseau = row[54]
  action_conf_reseau = row[55]


  modele = Modele.find_or_create_by(title: row[9],
                                    published: true,
                                    categorie: type,
                                    nb_elts: nb_elts,
                                    architecture: archi,
                                    u: u,
                                    marque: marque)

  type_composant_alim = TypeComposant.find_by_title('ALIM')
  nb_elts.to_i.times do
    Composant.create(modele: modele,
                      type_composant: type_composant_alim
    )
  end unless modele.composants.to_a.reject!{|c| c.type_composant != type_composant_alim}.present?

  type_composant_cm = TypeComposant.find_by_title('CM')
  rj45_cm.to_i.times do
    Composant.create(modele: modele,
                     type_composant: type_composant_cm
    )
  end unless modele.composants.to_a.reject!{|c| c.type_composant != type_composant_cm}.present?

  type_composant_ipmi = TypeComposant.find_by_title('IPMI')
  ipmi_futur.to_i.times do
    Composant.create(modele: modele,
                     type_composant: type_composant_ipmi
    )
  end unless modele.composants.to_a.reject!{|c| c.type_composant != type_composant_ipmi}.present?

  Serveur.create!(
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
      id_baie: id_baie,
      baie: baie,
      pdu_ondule: pdu_ondule,
      pdu_normal: pdu_normal,
      localisation: localisation,
      armoire: rack,
      nom: nom,
      # categorie: type,
      # nb_elts: nb_elts,
      # architecture: archi,
      # u: u,
      # marque: marque,
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
      # slots: [slot1, slot2, slot3, slot4, slot5, slot6, slot7]
  )
end
