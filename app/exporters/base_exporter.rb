# frozen_string_literal: true

class BaseExporter
  class UndefinedAttributeError < StandardError
    def initialize(attribute, model, exporter)
      super("Attribute '#{attribute}' is not defined by either #{model.class} or #{exporter.class}")
    end
  end

  DEFAULT_ATTRIBUTE_NAMES = %w[id created_at updated_at].freeze

  cattr_accessor :model_klass

  def initialize(records, attribute_names)
    @records = records
    @attribute_names = attribute_names
  end

  def to_csv
    CSV.generate do |csv|
      csv << headers

      process_data_to_rows do |row|
        csv << row
      end
    end
  end

  private

  def model_klass
    @model_klass ||= self.class.model_klass \
        || self.class.name.chomp("Exporter").safe_constantize \
        || raise("Can't find model for #{self.class.name}")
  end

  def headers
    @headers ||= attributes.map { |attr| model_klass.human_attribute_name(attr) }
  end

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
      raise UndefinedAttributeError.new(attribute_name, record, self)
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
