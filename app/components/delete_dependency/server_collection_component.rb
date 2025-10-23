# frozen_string_literal: true

module DeleteDependency
  class ServerCollectionComponent < ApplicationComponent
    erb_template <<~ERB
      <h4 class="mt-5"><%= Server.model_name.human %></h4>
      <%= render List::DataTableComponent.new(@servers) do |table| %>

        <% table.with_column(Server.human_attribute_name(:name), name: :name) do |server| %>
          <%= link_to server.name, server_path(server), class: "fw-bold", data: { turbo_frame: :_top }, target: "_blank" %>
        <% end %>

        <% table.with_column(Server.human_attribute_name(:numero), name: :numero) do |server| %>
          <%= link_to server.numero, server_path(server), class: "fw-bold", data: { turbo_frame: :_top }, target: "_blank" %>
        <% end %>

        <% table.with_column(Modele.human_attribute_name(:category), name: :"modele_category_id") do |server| %>
          <%= link_to server.modele.category, category_path(server.modele.category),
                      data: { turbo_frame: :_top }, target: "_blank" if server.modele.try(:category) %>
        <% end %>

        <% table.with_column(Server.human_attribute_name(:room), name: :room) do |server| %>
          <%= link_to server.room, room_path(server.room), data: { turbo_frame: :_top }, target: "_blank" if server.room %>
        <% end %>

        <% table.with_column(Islet.model_name.human, name: :islet_id) do |server| %>
          <%= link_to server.islet, islet_path(server.islet), data: { turbo_frame: :_top }, target: "_blank" if server.islet %>
        <% end %>

        <% table.with_column(Bay.model_name.human, name: :bay_id) do |server| %>
          <%= link_to server.bay, bay_path(server.bay), data: { turbo_frame: :_top }, target: "_blank" if server.bay %>
        <% end %>

        <% table.with_column(Server.human_attribute_name(:network_types), name: :network_types) do |server| %>
          <%= server.decorated.network_types_to_human %>
        <% end %>

        <% table.with_column(Server.human_attribute_name(:position), name: :position) do |server| %>
          <%= server.position %>
        <% end %>
      <% end %>
    ERB

    def initialize(servers)
      @servers = servers
      super
    end
  end
end
