# frozen_string_literal: true

json.extract! @server, :id, :category_id, :name, :nb_elts, :architecture_id, :u, :manufacturer_id, :modele_id, :numero,
              :cluster, :critique, :domaine_id, :gestion_id, :fc_total, :fc_utilise, :rj45_total, :rj45_utilise, :rj45_futur, :ipmi_utilise, :ipmi_futur, :rg45_cm, :ipmi_dedie, :created_at, :updated_at
