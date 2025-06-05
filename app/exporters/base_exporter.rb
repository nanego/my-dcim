# frozen_string_literal: true

class BaseExporter
  def initialize(records, attributes)
    @records = records
    @attributes = attributes
  end

  def process
    @records.map do |record|
      {}.tap do |new_record|
        @attributes.each do |attribute|
          # If model has this attribute, call it
          # If the exporter has a public method with the same attribute name, call it
          # Otherwise, raise an exception
        end
      end
    end
  end
end
