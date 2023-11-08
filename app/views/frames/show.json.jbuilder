# frozen_string_literal: true

json.extract! @frame, :id, :name, :u, :position, :switch_slot, :created_at, :updated_at

json.bay @frame.bay, :id, :name
json.pdus @frame.pdus, :id, :name, :modele_id
json.servers @frame.servers, :id, :name, :modele_id
json.islet @frame.islet, :id, :name, :room_id
json.room @frame.room, :id, :name, :site_id
