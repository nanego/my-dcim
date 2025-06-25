# frozen_string_literal: true

class BaseExporter
  class UndefinedAttributeExporter < StandardError
    def initialize(attribute, model, exporter)
      super("Attribute '#{attribute}' is not defined by either #{model} or #{exporter}")
    end
  end

  DEFAULT_ATTRIBUTE_NAMES = %w[id created_at updated_at].freeze

  def initialize(records, attribute_names)
    @records = records
    @attribute_names = attribute_names
  end

  def to_csv
    return "" if @records.empty?

    model = @records.first.class

    CSV.generate(headers: true) do |csv|
      csv << attributes.map { |attr| model.human_attribute_name(attr) }

      process_data_to_rows do |row|
        csv << row
      end
    end
  end

  private

  def process_data_to_rows
    @records.each do |record|
      values = attributes.map do |attribute_name|
        record_attribute_value(record, attribute_name)
      end

      yield values
    end
  end

  def attributes
    @attributes ||= (self.class::DEFAULT_ATTRIBUTE_NAMES + @attribute_names).uniq
  end

  def record_attribute_value(record, attribute_name)
    if respond_to?(attribute_name)
      public_send(attribute_name, record)
    elsif record.respond_to?(attribute_name)
      format_value(record.public_send(attribute_name))
    else
      raise UndefinedAttributeExporter.new(attribute_name, record.class, self.class)
    end
  end

  def format_value(value)
    case value
    when Array
      value.join(";")
    else
      value
    end
  end
end
