# frozen_string_literal: true

json.extract! @server, :id, :name, :modele_id, :numero,
              :cluster, :critique, :domaine_id, :gestion_id, :fc_total, :fc_utilise, :ipmi_dedie, :created_at, :updated_at
