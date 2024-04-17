# frozen_string_literal: true

class CardComponent < ApplicationComponent
  TYPES = %i[default primary success info warning danger].freeze

  renders_one :header
  renders_one :footer

  erb_template <<~ERB
    <div class="panel panel-<%= @type %>">

      <% if header? %>
      <div class="panel-heading">
        <%= header %>
      </div>
      <% end %>

      <div class="panel-body">
        <%= content %>
      </div>

      <% if footer? %>
      <div class="panel-footer">
        <%= footer %>
      </div>
      <% end %>
    </div>
  ERB

  def initialize(type: :default)
    raise ArgumentError, "#{type} is not a valid type" unless TYPES.include?(type)

    @type = type

    super
  end
end
