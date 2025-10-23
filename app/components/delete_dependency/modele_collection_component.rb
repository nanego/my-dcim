# frozen_string_literal: true

module DeleteDependency
  class ModeleCollectionComponent < ApplicationComponent
    include ModelesHelper

    erb_template <<~ERB
      <h4 class="mt-5"><%= Modele.model_name.human %></h4>
      <%= render List::DataTableComponent.new(@modeles) do |table| %>

        <% table.with_column(class: "p-0", style: "width: 40px; height: 40px;") do |modele| %>
          <% bgModeleColor = modele.try(:color) || lighten_color("#\#{Digest::MD5.hexdigest(modele.try(:name) || "test")[0..5]}", 0.4) %>
          <div class="h-100" style="background-color: <%= bgModeleColor %> !important;"></div>
        <% end %>

        <% table.with_column(Modele.model_name.human) do |modele| %>
          <%= link_to modele, modele_path(modele), class: "fw-bold", data: { turbo_frame: :_top }, target: "_blank" %>
        <% end %>

        <% table.with_column(Enclosure.human_attribute_name(:display)) do |modele| %>
          <%= modele.decorated.displays_to_human %>
        <% end %>

        <% table.with_column(Server.model_name.human(count: 2)) do |modele| %>
          <%= link_to servers_path(modele_ids: modele.id), data: { turbo_frame: :_top }, target: "_blank" do %>
            <%= pluralize(modele.servers.count,
                          modele.category.name.try(:downcase),
                          "\#{modele.category.name.try(:downcase)}\#{modele.category.name.blank? ||
                            modele.category.name.end_with?("s") ||
                            modele.category.name == "San" ||
                            modele.category.name.end_with?("eau") ? "" : "s"}")
            %>
          <% end %>
        <% end %>

        <% table.with_column(Modele.human_attribute_name(:network_types)) do |modele| %>
          <%= modele.decorated.network_types_to_human %>
        <% end %>
      <% end %>
    ERB

    def initialize(modeles)
      @modeles = modeles
      super
    end
  end
end
