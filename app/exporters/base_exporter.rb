# frozen_string_literal: true

class BaseExporter
  def initialize(records, attributes)
    @records = records
    @attributes = attributes
  end

  def process_data
    @records.map do |record|
      {}.tap do |new_record|
        @attributes.each do |attribute|
          new_record[attribute] = format_value(record_attribute_value(record, attribute))
        end
      end
    end
  end

  private

  def record_attribute_value(record, attribute)
    if record.respond_to? attribute
      record.public_send(attribute)
    elsif respond_to? attribute
      public_send(attribute, record)
    else
      raise "Attribute '#{attribute}' is not defined by either #{record.class} or #{self.class}"
    end
  end

  def format_value(value)
    value.to_s.gsub(/[\r\n]+/, ' ')
  end
end
