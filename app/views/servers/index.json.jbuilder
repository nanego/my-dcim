json.array!(@servers) do |server|
  json.extract! server, :id, :category_id, :name, :nb_elts, :architecture_id, :u, :manufacturer_id, :modele_id, :numero, :conso, :cluster, :critique, :domaine_id, :gestion_id, :room_id, :islet, :fc_total, :fc_utilise, :rj45_total, :rj45_utilise, :rj45_futur, :ipmi_utilise, :ipmi_futur, :rg45_cm, :ipmi_dedie
  json.url server_url(server, format: :json)
end
