# frozen_string_literal: true

module Enum
  module Array
    extend ActiveSupport::Concern

    MISSING_VALUE_MESSAGE = "%<value>s is not a valid value for %<attr>s" # rubocop:disable Style/FormatStringToken
    private_constant :MISSING_VALUE_MESSAGE

    class_methods do
      def array_enum(name = nil, mapping = nil, validate: false)
        name = name.to_s
        mapping_hash = ActiveSupport::HashWithIndifferentAccess.new(mapping)

        defined_enums[name] = mapping_hash

        define_singleton_method(name.pluralize) do
          mapping_hash
        end

        define_singleton_method("with_#{name}") do |*values|
          db_values = values.map do |value|
            raise_missing_value(name, value) unless mapping_hash.key?(value)

            mapping_hash[value]
          end

          # get sql type to cast properly
          # It returns the array's element type
          element_type = columns_hash[name.to_s].sql_type

          # encode array so it can be understood by PG
          encoder = PG::TextEncoder::Array.new
          encoded = encoder.encode(db_values)

          where(
            "#{name} @> ?::#{element_type}[]",
            encoded,
          )
        end

        define_method(name) do
          Array(self[name]).map { |value| mapping_hash.key(value) || value }
        end

        define_method(:"#{name}=") do |values|
          self[name] = Array(values).compact_blank.map do |value|
            raise_missing_value(name, value) unless validate || mapping_hash.key?(value)

            mapping_hash[value] || value
          end.uniq
        end

        validates name, array_inclusion: { in: mapping_hash.keys } if validate
      end

      private

      def raise_missing_value(name, value)
        raise ArgumentError, format(MISSING_VALUE_MESSAGE, name:, value:)
      end
    end
  end
end
