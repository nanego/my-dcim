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

Serveur.delete_all

case ActiveRecord::Base.connection.adapter_name
  when 'SQLite'
    update_seq_sql = "update sqlite_sequence set seq = 0 where name = 'serveurs';"
    ActiveRecord::Base.connection.execute(update_seq_sql)
  when 'PostgreSQL'
    ActiveRecord::Base.connection.reset_pk_sequence!("serveurs")
    ActiveRecord::Base.connection.reset_pk_sequence!("slots")
  else
    raise "Task not implemented for this DB adapter"
end
puts "Table Serveurs vide et pk_sequence = 0"

file = File.read(Rails.root.join('lib', 'seeds', 'inventaire_160127.csv'))
csv = CSV.parse(file, :headers => true)

puts "Importation en cours"
csv.each_with_index do |row, i|
  # puts ((i/369).to_i).to_s+'%' if i % 50 == 0

  # Localisation,Rack,Nom du matériel,Type,Nb Elts,Architecture,U,MARQUE,MODELE,numéro de série,CONSO(Watt),I,PDUOndulé,PDUNormal,cluster,critique,domaine,gestion,Action,Phase,Salle,Îlot,"FCTotal","FCUtilisé","RJ45Total","RJ45Utilisé","RJ45Futur","IPMIUtilisé","IPMIFutur","RJ45CM","IPMIDédié",Slot 1,Slot 2,Slot 3,Slot 4,Slot 5,Slot 6,Slot 7,,,,,,

  localisation = Localisation.find_or_create_by(title: row[0], published: true)
  rack = Armoire.find_or_create_by(title: row[1], published: true)
  nom = row[2]
  type = Categorie.find_or_create_by(title: row[3], published: true)
  nb_elts = row[4]
  archi = Architecture.find_or_create_by(title: row[5], published: true)
  u = row[6]
  marque = Marque.find_or_create_by(title: row[7], published: true)
  modele = Modele.find_or_create_by(title: row[8], published: true)
  numero = row[9]
  conso = row[10]
  i = row[11]
  pdu_ondule = row[12]
  pdu_normal = row[13]
  cluster = row[14].present?
  critique = row[15].present?
  domaine = Domaine.find_or_create_by(title: row[16], published: true)
  gestion = Gestion.find_or_create_by(title: row[17], published: true)
  action = Acte.find_or_create_by(title: row[18], published: true)
  phase = row[19]
  salle = Salle.find_or_create_by(title: row[20], published: true)
  ilot = row[21]
  fc_total = row[22]
  fc_utilise  = row[23]
  rj45_utilise = row[24]
  rj45_futur = row[25]
  ipmi_utilise = row[26]
  ipmi_futur = row[27]
  rj45_cm = row[28]
  ipmi_dedie = row[29]
  slot1 = Slot.create!(numero: 1, valeur: row[30])
  slot2 = Slot.create!(numero: 2, valeur: row[31])
  slot3 = Slot.create!(numero: 3, valeur: row[32])
  slot4 = Slot.create!(numero: 4, valeur: row[33])
  slot5 = Slot.create!(numero: 5, valeur: row[34])
  slot6 = Slot.create!(numero: 6, valeur: row[35])
  slot7 = Slot.create!(numero: 7, valeur: row[36])


  Serveur.create!(
      localisation: localisation,
      armoire: rack,
      nom: nom,
      categorie: type,
      nb_elts: nb_elts,
      architecture: archi,
      u: u,
      marque: marque,
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
      ipmi_utilise: ipmi_utilise,
      slots: [slot1, slot2, slot3, slot4, slot5, slot6, slot7]
  )
end
