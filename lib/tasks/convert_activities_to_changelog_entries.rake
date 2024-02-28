# frozen_string_literal: true

require "benchmark"

task convert_activities_to_changelog_entries: :environment do
  # Backport old Rails code to make PublicActivity parameters export works
  module ActiveRecord # rubocop:disable Lint/ConstantDefinitionInBlock
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

    module LegacyYamlAdapter # :nodoc:
      def self.convert(coder)
        return coder unless coder.is_a?(Psych::Coder)

        case coder["active_record_yaml_version"]
        when 1, 2 then coder
        else
          klass = coder.tag.gsub("!ruby/object:", "").safe_constantize

          if coder["attributes"].is_a?(ActiveModel::AttributeSet)
            Rails420.convert(klass, coder)
          else
            Rails41.convert(klass, coder)
          end
        end
      end

      module Rails420 # :nodoc:
        def self.convert(klass, coder)
          attribute_set = coder["attributes"]

          klass.attribute_names.each do |attr_name|
            attribute = attribute_set[attr_name]
            if attribute.type.is_a?(Delegator)
              type_from_klass = klass.type_for_attribute(attr_name)
              attribute_set[attr_name] = attribute.with_type(type_from_klass)
            end
          end

          coder
        end
      end

      module Rails41 # :nodoc:
        def self.convert(klass, coder)
          attributes = klass.attributes_builder
                            .build_from_database(coder["attributes"])
          new_record = coder["attributes"][klass.primary_key].blank?

          {
            "attributes" => attributes,
            "new_record" => new_record,
          }
        end
      end
    end
  end

  module ActiveModel # rubocop:disable Lint/ConstantDefinitionInBlock
    module Type
      class Text < String # :nodoc:
        def type
          :text
        end
      end
    end
  end

  def convert_activity_to_changes(activity)
    old_data = activity.read_attribute_before_type_cast(:parameters)

    return {} if old_data.blank?

    data = YAML.unsafe_load(old_data)

    raise "Activity#parameters shouw be a Hash, #{data.class} given." unless data.is_a?(Hash)

    data.to_h do |k, v|
      case v
      when Array
        [k, v]
      when ApplicationRecord, Hash
        [nil, nil]
      else
        [k, [nil, v]]
      end
    end.compact
  end

  def convert_old_object_type(type)
    case type
    when "Marque" then "Manufacturer"
    else
      type
    end
  end

  # https://discuss.rubyonrails.org/t/cve-2022-32224-possible-rce-escalation-bug-with-serialized-columns-in-active-record/81017
  ActiveRecord.use_yaml_unsafe_load = true

  # ChangelogEntry.delete_all

  failed_count = 0

  # activities = PublicActivity::Activity.where(id: [74435, 74912, 74085])
  # activities = PublicActivity::Activity.where(id: [74085])
  # activities = PublicActivity::Activity.where(id: [18590])
  # activities = PublicActivity::Activity.where(created_at: ...5.years.ago)
  # activities = PublicActivity::Activity.where(created_at: 1.years.ago..Time.zone.now)
  # activities = PublicActivity::Activity.where(created_at: 6.years.ago..5.years.ago) # F
  # activities = PublicActivity::Activity.where(created_at: 7.years.ago..6.years.ago) # F
  # activities = PublicActivity::Activity.where(created_at: 8.years.ago..7.years.ago) # OK
  activities = PublicActivity::Activity.all

  time = Benchmark.measure do
    activities.find_each do |activity|
      if ChangelogEntry.where("metadata->>'activity_id' = ?", activity.id.to_s).any?
        print "\e[33ms\e[0m"
        next
      end

      data = {}
      failed = false

      begin
        data = convert_activity_to_changes(activity)
      rescue
        failed = true
      end

      entry = ChangelogEntry.new(
        object_id: activity.trackable_id,
        object_type: convert_old_object_type(activity.trackable_type),
        author_id: activity.owner_id,
        author_type: activity.owner_type,
        action: activity.key&.split(".")&.last,
        object_changed_attributes: data || {},
        metadata: {
          activity_id: activity.id,
          activity_parameters: activity.read_attribute_before_type_cast(:parameters),
          activity_import_failed: failed,
        },
        created_at: activity.created_at,
        updated_at: activity.updated_at,
      )
      entry.save!(validate: false)

      print "\e[32m.\e[0m"
    rescue StandardError
      # puts ""
      # pp activity.id
      # pp e

      # binding.b
      # exit

      print "\e[31mF\e[0m"
      # puts activity.id
      # exit

      failed_count += 1
    end
  end

  puts <<~RESULT


    #{activities.count} activities has been processed in #{time.total.round(2)}s
    #{failed_count} has failed to be imported
  RESULT
end
