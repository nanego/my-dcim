# frozen_string_literal: true

json.extract! @server, :id, :name, :modele, :numero,
              :cluster, :critique, :domaine, :gestion, :fc_total, :fc_utilise, :ipmi_dedie, :created_at, :updated_at
