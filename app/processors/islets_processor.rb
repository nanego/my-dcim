# frozen_string_literal: true

class IsletsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name rooms.name sites.name position].freeze

  map :q do |q:|
    raw.where(Islet.arel_table[:name].matches("%#{q}%"))
      .or(raw.where(id: q))
  end

  map :room_id do |room_id:|
    raw.where(room_id: room_id)
  end

  map :site_id do |site_id:|
    raw.joins(:site).where(site: { id: site_id })
  end

  sortable fields: SORTABLE_FIELDS
end
