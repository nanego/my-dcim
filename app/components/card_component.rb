# frozen_string_literal: true

class CardComponent < ApplicationComponent
  renders_one :header
  renders_one :footer

  erb_template <<~ERB
    <div class="panel panel-<%= @state %>">

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

  def initialize(state = :default)
    @state = state

    super
  end
end
