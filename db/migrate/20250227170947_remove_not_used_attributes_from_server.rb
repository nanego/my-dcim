# frozen_string_literal: true

class RemoveNotUsedAttributesFromServer < ActiveRecord::Migration[8.0]
  def change
    change_table :servers, bulk: true do |t|
      t.remove :pdu_ondule, :pdu_normal, type: :string
      t.remove :fc_total, :fc_utilise, :fc_calcule, type: :integer
      # t.remove :fc_total, :fc_utilise, :fc_calcule, :fc_futur, type: :integer
      t.remove :rj45_total, :rj45_utilise, :rj45_cm, :rj45_calcule, type: :integer
      # t.remove :rj45_total, :rj45_utilise, :rj45_cm, :rj45_calcule, :rj45_futur, type: :integer
      t.remove :ipmi_utilise, :ipmi_futur, :ipmi_dedie, type: :integer
      t.remove :tenGbps_futur, type: :integer
      t.remove :hostname, type: :string
      t.remove :etat_conf_reseau, :action_conf_reseau, type: :string
      t.remove :i, :ip, type: :string
      t.remove :color, type: :string
    end
  end
end
