# frozen_string_literal: true

task convert_activities_to_changelog_entries: :environment do
  module ActiveRecord
    module ConnectionAdapters
      module PostgreSQL
        module OID # :nodoc:
          module Infinity # :nodoc:
            def infinity(options = {})
              options[:negative] ? -::Float::INFINITY : ::Float::INFINITY
            end
          end

          class Integer < Type::Integer # :nodoc:
            include Infinity
          end
        end
      end
    end
  end

  # https://discuss.rubyonrails.org/t/cve-2022-32224-possible-rce-escalation-bug-with-serialized-columns-in-active-record/81017
  ActiveRecord.use_yaml_unsafe_load = true

  PublicActivity::Activity.limit(2000).find_each do |activity|
    next if ChangelogEntry.where("metadata->>'activity_id' = ?", activity.id.to_s).any?

    ChangelogEntry.create!(
      object_id: activity.trackable_id,
      object_type: activity.trackable_type,
      author_id: activity.owner_id,
      author_type: activity.owner_type,
      action: activity.key.split(".").last,
      object_changes: activity.parameters.presence || {},
      metadata: {
        activity_id: activity.id
      }
    )
    print "."
  rescue StandardError
    # pp e
    # binding.pry
  end
end
