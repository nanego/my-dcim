# frozen_string_literal: true

class ApplicationProcessor < Rubanok::Processor
  SORT_ORDERS = %w[asc desc].freeze

  def self.sortable(fields:, orders: SORT_ORDERS)
    match :sort_by, :sort do
      yield if block_given?

      default do |sort_by:, sort: "asc"|
        raise "Possible injection: #{sort}" unless orders.include?(sort)
        raise "The field is not sortable: #{sort_by}" unless fields.include?(sort_by)

        raw.order(sort_by => sort)
      end
    end
  end
end
