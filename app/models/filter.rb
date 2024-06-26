# frozen_string_literal: true

class Filter
  include ActiveModel::Conversion
  extend ActiveModel::Translation

  delegate :model_name, to: :class

  def initialize(records, params, with: nil)
    @records = records
    @params = params
    @rubanok_class = with || "#{records&.klass&.to_s&.pluralize}Processor".safe_constantize

    raise "Processor class missing" unless @rubanok_class
  end

  class << self
    def model_name
      @model_name ||= begin
        namespace = module_parents.detect do |n|
          n.respond_to?(:use_relative_model_naming?) && n.use_relative_model_naming?
        end
        Name.new(self, namespace)
      end
    end

    def i18n_scope
      :filters
    end
  end

  def results
    @results ||= @rubanok_class.call(@records, attributes)
  end

  def filled?
    @filled ||= attributes.values.any?(&:present?)
  end

  def filled_attributes
    @filled_attributes ||= attributes.select { |k, v| v.present? }
  end

  def attributes
    @attributes ||= @params.respond_to?(:permit) ? @params.permit(*attribute_names).to_h : @params
  end
  alias to_h attributes

  def attribute_names
    @attribute_names ||= @rubanok_class.fields_set.to_a
  end

  def total_count
    @total_count ||= @records.count
  end

  def results_count
    @results_count ||= results.count
  end

  private

  def method_missing(symbol, *)
    return attributes[symbol] if attribute_names.include?(symbol)

    super
  end

  def respond_to_missing?(symbol, include_all)
    return true if attribute_names.include?(symbol)

    super
  end

  class Name < ActiveModel::Name
    def param_key
      ""
    end
  end
end
