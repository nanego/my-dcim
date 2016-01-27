json.array!(@slots) do |slot|
  json.extract! slot, :id, :numero, :serveur_id, :valeur
  json.url slot_url(slot, format: :json)
end
