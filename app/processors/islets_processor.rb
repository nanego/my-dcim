# frozen_string_literal: true

class IsletsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name rooms.name sites.name position].freeze

  map :q do |q:|
    raw.where(Islet.arel_table[:name].matches("%#{q}%"))
      .or(raw.where(id: q))
  end

  map :room_ids, filter_with: :non_empty_array do |room_ids:|
    raw.joins(:room).where(room_id: room_ids)
  end

  map :site_ids, filter_with: :non_empty_array do |site_ids:|
    raw.joins(room: :site).where(sites: { id: site_ids })
  end

  sortable fields: SORTABLE_FIELDS
end
