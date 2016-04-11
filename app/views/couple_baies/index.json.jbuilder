json.array!(@couple_baies) do |couple_baie|
  json.extract! couple_baie, :id, :baie_one_id, :baie_two_id, :create, :update, :index, :show
  json.url couple_baie_url(couple_baie, format: :json)
end
