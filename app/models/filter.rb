# frozen_string_literal: true

class Filter
  include ActiveModel::Conversion
  extend ActiveModel::Translation

  attr_reader :attribute_names

  delegate :model_name, to: :class

  def initialize(params, attribute_names)
    @params = params.dup
    @attribute_names = attribute_names
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

  def persisted?
    false
  end

  def filled?(attribute_name = nil)
    return attributes[attribute_name].present? if attribute_name

    attributes.values.any?(&:present?)
  end

  def filled_attributes
    @filled_attributes ||= attributes.compact_blank
  end

  def attributes
    @attributes ||= if @params.respond_to?(:permit)
                      _compact_attributes @params.permit(*_permitted_attributes_names).to_h
                    else
                      _compact_attributes @params.with_indifferent_access
                    end
  end
  alias to_h attributes

  private

  def method_missing(symbol, *args)
    method_name = symbol.to_s

    return attributes[symbol] if attribute_names.include?(symbol)

    if method_name.end_with?("=") && attribute_names.include?(method_name.chop.to_sym) # rubocop:disable Style/IfUnlessModifier
      return attributes[method_name.chop.to_sym] = args.first
    end

    super
  end

  def respond_to_missing?(symbol, include_all)
    method_name = symbol.to_s

    return true if attribute_names.include?(symbol)
    return true if method_name.end_with?("=") && attribute_names.include?(method_name.chop.to_sym)

    super
  end

  def _permitted_attributes_names
    attribute_names.map do |attribute_name|
      if attribute_name.end_with?("_ids")
        { attribute_name => [] }
      else
        attribute_name
      end
    end
  end

  def _compact_attributes(attributes)
    attributes.transform_values do |v|
      case v
      when Array
        v.compact_blank
      else
        v
      end
    end
  end

  class Name < ActiveModel::Name
    def param_key
      ""
    end
  end
end
