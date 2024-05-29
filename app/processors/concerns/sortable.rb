# frozen_string_literal: true

module Sortable
  extend ActiveSupport::Concern

  SORT_ORDERS = %w[asc desc].freeze

  class_methods do
    def sortable(fields:, orders: SORT_ORDERS)
      match :sort_by, :sort do
        default do |sort_by:, sort: "asc"|
          raise "Possible injection: #{sort}" unless orders.include?(sort.to_s)
          raise "The field is not sortable: #{sort_by}" unless fields.include?(sort_by.to_s)

          raw.reorder(sort_by => sort)
        end

        yield if block_given?
      end
    end
  end
end
