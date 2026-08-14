# frozen_string_literal: true

module ModelMatchers
  class ValidateArrayInclusionOf
    def initialize(attribute)
      @attribute = attribute
    end

    def in(values)
      @values = values
      self
    end

    def matches?(record)
      raise ArgumentError, "Call `.in(values)` before using this matcher" unless @values

      @record = record

      @record.public_send("#{@attribute}=", @values)
      return false unless @record.valid?

      @record.public_send("#{@attribute}=", @values + [invalid_value])
      return false if @record.valid?

      @record.errors.added?(@attribute, :contains_unpermitted_values, wrong_values: invalid_value)
    end

    def description
      "validate #{@attribute} contains only allowed values"
    end

    def failure_message
      "expected #{@record.class} to validate that #{@attribute} only includes allowed values"
    end

    def failure_message_when_negated
      "expected #{@record.class} not to validate that #{@attribute} only includes allowed values"
    end

    private

    def invalid_value
      @invalid_value ||= begin
        value = "__invalid_value__"
        value = "_#{value}_" while @values.include?(value)
        value
      end
    end
  end

  def validate_array_inclusion_of(attribute)
    ValidateArrayInclusionOf.new(attribute)
  end
end

RSpec.configure do |config|
  config.include ModelMatchers, type: :model
end
