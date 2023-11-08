# frozen_string_literal: true

json.extract! @islet, :id, :name, :position, :room, :created_at, :updated_at
json.bays @islet.bays, :id, :name, :bay_type, :lane, :position
