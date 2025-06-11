# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Changelogable

  primary_abstract_class

  self.store_attribute_unset_values_fallback_to_default = true

  class << self
    def export_to_csv(records, attributes)
      data = exporter.new(records, attributes).process_data

      CSV.generate(headers: true) do |csv|
        csv << attributes.map { |attr| human_attribute_name(attr) }

        data.each do |record|
          csv << record.values
        end
      end
    end

    private

    def exporter
      @exporter ||= "#{name}Exporter".classify.constantize
    rescue NameError
      BaseExporter
    end
  end
end
