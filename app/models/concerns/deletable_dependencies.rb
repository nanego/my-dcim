# frozen_string_literal: true

module DeletableDependencies
  extend ActiveSupport::Concern

  ALLOW_DEPEDENCY_OPTIONS = %i[
    restrict_with_error
    destroy
  ].freeze

  included do
    class_attribute :delete_dependency_config, instance_writer: false, default: {}
  end

  class_methods do
    def delete_dependency(only: nil, except: nil)
      self.delete_dependency_config = {
        only: Array(only).map(&:to_sym),
        except: Array(except).map(&:to_sym),
      }
    end
  end

  def delete_dependencies
    self.class
      .reflect_on_all_associations
      .filter_map do |a|
        # exclude according to config
        next unless association_counts?(a)

        # get records
        records = public_send(a.name)
        next if records.blank?

        {
          klass: a.klass,
          records:,
        }
      end
  end

  private

  def association_counts?(asso)
    only = delete_dependency_config[:only]
    expect = delete_dependency_config[:expect]

    # only is above default config
    return only.include?(asso.name) unless only.nil?

    # default behavior
    return false unless ALLOW_DEPEDENCY_OPTIONS.include?(asso.options[:dependent])
    return false unless asso.name != changelog_entries

    # exept is not above default config
    expect.nil? || expect.exclude?(asso.name)
  end
end
