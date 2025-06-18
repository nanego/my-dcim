# frozen_string_literal: true

class BaseExporter
  def initialize(records, attribute_names)
    @records = records
    @attribute_names = attribute_names
  end

  def process_data
    @records.map do |record|
      @attribute_names.index_with do |attribute_name|
        record_attribute_value(record, attribute_name)
      end
    end
  end

  class UndefinedAttributeExporter < StandardError
    def initialize(attribute, model, exporter)
      super("Attribute '#{attribute}' is not defined by either #{model} or #{exporter.class}")
    end
  end

  private

  def record_attribute_value(record, attribute_name)
    if respond_to? attribute_name
      public_send(attribute_name, record)
    elsif record.respond_to? attribute_name
      format_value(record.public_send(attribute_name))
    else
      raise UndefinedAttributeExporter.new(attribute_name, record.class, self)
    end
  end

  def format_value(value)
    case value
    when Array
      value.join(';').gsub(/[\r\n]+/, ' ')
    when String
      value.gsub(/[\r\n]+/, ' ')
    else
      value
    end
  end
end
