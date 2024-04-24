# frozen_string_literal: true

class RoomsProcessor < ApplicationProcessor
  map :name do |name:|
    raw.where(Room.arel_table[:name].matches("%#{name}%"))
  end

  map :site_id do |site_id:|
    raw.where(site_id: site_id)
  end
end
