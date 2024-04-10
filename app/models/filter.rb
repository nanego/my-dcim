# frozen_string_literal: true

class Filter
  extend ActiveModel::Translation

  def initialize(records, params, with: nil)
    @records = records
    @params = params
    @rubanok_class = with || "#{params[:controller].classify.pluralize}Processor".safe_constantize

    raise "Processor class missing" unless @rubanok_class
  end

  def results
    @results ||= @rubanok_class.call(@records, attributes)
  end

  def fill?
    @fill ||= attributes.values.any?(&:present?)
  end

  def attributes
    @attributes ||= @params.permit(*attribute_names)
  end
  alias to_h attributes

  def attribute_names
    @attribute_names ||= @rubanok_class.fields_set
  end

  def method_missing(symbol, *args)
    return attributes[symbol] if attribute_names.include?(symbol)

    super(symbol, *args)
  end

  def respond_to_missing?(symbol, include_all)
    return true if attribute_names.include?(symbol)

    super(symbol, include_all)
  end

  def model_name
    self.class.model_name
  end

  def self.model_name
    @model_name ||= begin
      namespace = module_parents.detect do |n|
        n.respond_to?(:use_relative_model_naming?) && n.use_relative_model_naming?
      end
      Name.new(self, namespace)
    end
  end

  class Name < ActiveModel::Name
    def param_key
      ""
    end
  end
end
