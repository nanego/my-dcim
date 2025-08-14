# frozen_string_literal: true

class BaysProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[lane position rooms.name islets.name width depth bay_type_id access_control].freeze

  map :q do |q:|
    raw.joins(:frames)
      .where(
        Frame.arel_table[:name].matches("%#{q}%")
          .or(Bay.arel_table[:id].eq(q))
      )
  end

  map :room_ids, filter_with: :non_empty_array do |room_ids:|
    raw.joins(islet: :room).where(rooms: { id: room_ids })
  end

  map :islet_ids, filter_with: :non_empty_array do |islet_ids:|
    raw.where(islet_id: islet_ids)
  end

  map :manufacturer_ids, filter_with: :non_empty_array do |manufacturer_ids:|
    raw.where(manufacturer_id: manufacturer_ids)
  end

  sortable fields: SORTABLE_FIELDS
end
