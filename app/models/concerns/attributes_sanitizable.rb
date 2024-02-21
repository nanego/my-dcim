# frozen_string_literal: true

# Sanitize attributes to remove blank values on String or Array.
#
# @param attrs [Symbol, Array] list of attributes to sanitize
#   or could be `:all` to sanitze all attributes.
# @param except [Symbol, Array] list of attributes to not sanitize.
# @return [Hash] configuration of attributes to sanitize.
#
# @example Sanitize all attributes
#   class MyModel < ApplicationRecord
#     attr_sanitize :all
#   end
#
# @example Sanitize all attributes except some
#   class MyModel < ApplicationRecord
#     attr_sanitize :all, except: %i[name description]
#   end
#
# @example Sanitize only some attributes
#   class MyModel < ApplicationRecord
#     attr_sanitize :name, :description
#   end
module AttributesSanitizable
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :_attrs_to_sanitize

    def attr_sanitize(*attrs, except: nil)
      raise "attr_sanitize could be called only once" unless @_attrs_to_sanitize.nil?

      @_attrs_to_sanitize = { attrs: attrs, except: except }
    end
  end

  included do
    before_validation :sanitize_attributes
  end

  def sanitize_attributes
    attributes_to_sanitize.each do |attr|
      value = public_send(attr)
      public_send(:"#{attr}=", sanitize_value(value))
    end
  end

  private

  def attributes_to_sanitize
    attrs, except = attr_sanitize_configuration

    if attrs == [:all] || attrs.empty?
      attrs = model_attributes
      attrs.reject! { |a| except.to_a.include? a } unless except.nil?
    end

    attrs
  end

  def attr_sanitize_configuration
    config = self.class._attrs_to_sanitize || {}
    attrs = config.fetch(:attrs, []).compact.map(&:to_sym)

    [attrs, array_cast(config, :except)]
  end

  def array_cast(config, key)
    value = config.fetch(key, [])
    value = [value] if value.present? && !value.is_a?(Array)
    value
  end

  def model_attributes
    self.class.attribute_names.map(&:to_sym)
  end

  def sanitize_value(value)
    case value
    when Array
      return value.reject(&:blank?)
    when String
      return nil if value.blank?
    end

    value
  end
end
