json.array!(@serveurs) do |serveur|
  json.extract! serveur, :id, :localisation_id, :armoire_id, :category_id, :nom, :nb_elts, :architecture_id, :u, :marque_id, :modele_id, :numero, :conso, :cluster, :critique, :domaine_id, :gestion_id, :acte_id, :phase, :salle_id, :ilot, :fc_total, :fc_utilise, :rj45_total, :rj45_utilise, :rj45_futur, :ipmi_utilise, :ipmi_futur, :rg45_cm, :ipmi_dedie
  json.url serveur_url(serveur, format: :json)
end
