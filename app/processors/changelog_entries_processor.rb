# frozen_string_literal: true

class ChangelogEntriesProcessor < ApplicationProcessor
  map :q do |q:|
    q = q.downcase

    changelog_entries_table = ChangelogEntry.arel_table
    object_id_condition = changelog_entries_table[:object_id].eq(q.to_i)

    object_name_filtered_entries_ids = raw.to_a.select { |entry| entry.object_name.downcase.include?(q) }.pluck(:id)
    object_name_condition = changelog_entries_table[:id].in(object_name_filtered_entries_ids)

    combined_conditions = object_id_condition.or(object_name_condition)

    raw.where(combined_conditions)
  end

  map :actions, filter_with: :non_empty_array do |actions:|
    raw.where(action: actions)
  end

  map :authors, filter_with: :non_empty_array do |authors:|
    raw.where(author: authors)
  end

  map :object_types, filter_with: :non_empty_array do |object_types:|
    raw.where(object_type: object_types)
  end

  map :date do |date:|
    raw.where(created_at: Date.parse(date).all_day)
  end
end
