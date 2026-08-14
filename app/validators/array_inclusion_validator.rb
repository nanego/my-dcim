# frozen_string_literal: true

class ArrayInclusionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    not_allowed_values = values - options[:in]

    return if not_allowed_values.empty?

    wrong_values = not_allowed_values.join(", ")
    record.errors.add(attribute, :contains_unpermitted_values, wrong_values:)
  end
end
