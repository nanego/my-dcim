# frozen_string_literal: true

module Enum
  module Array
    extend ActiveSupport::Concern

    MISSING_VALUE_MESSAGE = "%<value>s is not a valid value for %<attr>s" # rubocop:disable Style/FormatStringToken
    private_constant :MISSING_VALUE_MESSAGE

    class_methods do
      def array_enum(name = nil, mapping = nil)
        name = name.to_s
        mapping_hash = ActiveSupport::HashWithIndifferentAccess.new(mapping)

        defined_enums[name] = mapping_hash

        define_singleton_method(name.pluralize) do
          mapping_hash
        end

        define_method(name) do
          Array(self[name]).map { |value| mapping_hash.key(value) }
        end

        define_method(:"#{name}=") do |values|
          self[name] = Array(values).compact_blank.map do |value|
            raise_missing_value(name, value) unless mapping_hash.key?(value)

            mapping_hash[value]
          end.uniq
        end

        validates name, array_inclusion: { in: mapping_hash.keys }
      end

      private

      def raise_missing_value(name, value)
        raise ArgumentError, "#{value} is not a valid value for #{name}"
      end
    end
  end
end
