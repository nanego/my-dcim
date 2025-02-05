# frozen_string_literal: true

class ServerDecorator < ApplicationDecorator
  def network_types_to_human
    return Modele.human_attribute_name("network_types.blank") unless (n_t = network_types.presence)

    n_t.map { |type| Modele.human_attribute_name("network_types.#{type}") }.join(", ")
  end

  class << self
    # Default columns that are displayed on Servers#Index
    def default_columns_preference
      %w[name numero type islet bay network_types]
    end

    # List of columns that can be displayed on Servers#Index
    def columns_preference
      %w[name numero type islet bay network_types]
    end
  end
end
