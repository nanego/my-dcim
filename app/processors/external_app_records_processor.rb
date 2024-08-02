# frozen_string_literal: true

class ExternalAppRecordsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[server_id servers.name servers.numero servers.frame external_name external_id external_serial].freeze

  sortable fields: SORTABLE_FIELDS do
    # having "name" do |sort: "asc"|
    #   raise "Possible injection: #{sort}" unless SORT_ORDERS.include?(sort)

    #   raw.order(name: sort)
    # end
  end
end
