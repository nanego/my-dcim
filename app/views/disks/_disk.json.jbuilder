json.extract! disk, :id, :server_id, :disk_type_id, :quantity, :created_at, :updated_at
json.url disk_url(disk, format: :json)