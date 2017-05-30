json.array!(@architectures) do |architecture|
  json.extract! architecture, :id, :name, :description, :published
  json.url architecture_url(architecture, format: :json)
end
