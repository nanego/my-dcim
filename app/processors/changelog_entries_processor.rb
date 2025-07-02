# frozen_string_literal: true

class ChangelogEntriesProcessor < ApplicationProcessor
  map :actions, filter_with: :non_empty_array do |actions:|
    raw.where(action: actions)
  end

  map :object_types, filter_with: :non_empty_array do |object_types:|
    raw.where(object_type: object_types)
  end

  map :date do |date:|
    raw.where(created_at: Date.parse(date).all_day)
  end
end
