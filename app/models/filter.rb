# frozen_string_literal: true

class Filter
  include ActiveModel::Conversion
  extend ActiveModel::Translation

  attr_reader :attribute_names

  delegate :model_name, to: :class

  def initialize(params, attribute_names)
    @params = params
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
