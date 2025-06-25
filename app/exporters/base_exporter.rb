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
    data = process_data(attributes)

    CSV.generate(headers: true) do |csv|
      csv << attributes.map { |attr| model.human_attribute_name(attr) }

      data.each do |record|
        csv << record.values
      end
    end
  end

  private

  def process_data(attribute_names)
    @records.map do |record|
      attribute_names.index_with do |attribute_name|
        record_attribute_value(record, attribute_name)
      end
    end
  end

  def attributes
    @attributes ||= (self.class::DEFAULT_ATTRIBUTE_NAMES + @attribute_names).uniq
  end

  def record_attribute_value(record, attribute_name)
    if respond_to? attribute_name
      public_send(attribute_name, record)
    elsif record.respond_to? attribute_name
      format_value(record.public_send(attribute_name))
    else
      raise UndefinedAttributeExporter.new(attribute_name, record.class, self.class)
    end
  end

  def format_value(value)
    normalize_line_endings = ->(str) { str.gsub("\r", "\\r").gsub("\n", "\\n") }

    case value
    when Array
      normalize_line_endings.call(value.join(";"))
    when String
      normalize_line_endings.call(value)
    else
      value
    end
  end
end
