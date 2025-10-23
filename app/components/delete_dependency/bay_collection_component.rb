# frozen_string_literal: true

module DeleteDependency
  class BayCollectionComponent < ApplicationComponent
    erb_template <<~ERB
      <h4 class="mt-5"><%= Bay.model_name.human %></h4>
      <%= render List::DataTableComponent.new(@bays) do |table| %>

        <% table.with_column(Bay.human_attribute_name(:name), name: :name) do |bay| %>
          <%= link_to bay_path(bay), class: "fw-bold", target: "_blank" do %>
            <% bay.frames.any? ? bay.to_s : bay.decorated.no_frame_warning_icon %>
          <% end %>
        <% end %>

        <% table.with_column(Room.model_name.human, name: :room_id) do |bay| %>
          <%= link_to bay.room, room_path(bay.room), target: "_blank" %>
        <% end %>

        <% table.with_column(Islet.model_name.human, name: :islet_id) do |bay| %>
          <%= link_to bay.islet.name_with_room, islet_path(bay.islet), target: "_blank" %>
        <% end %>

        <% table.with_column(Frame.model_name.human.pluralize, name: :frame_id) do |bay| %>
          <%=
            bay.frames.map do |frame|
              link_to(frame.name, frame_path(frame), target: "_blank")
            end.join(" / ").html_safe
          %>
        <% end %>

        <% table.with_column(Bay.human_attribute_name(:lane), name: :lane) do |bay| %>
          <%= bay.lane %>
        <% end %>

        <% table.with_column(Bay.human_attribute_name(:position), name: :position) do |bay| %>
          <%= bay.position %>
        <% end %>

        <% table.with_column(Bay.human_attribute_name(:width), name: :width) do |bay| %>
          <%= bay.width %>
        <% end %>

        <% table.with_column(Bay.human_attribute_name(:depth), name: :depth) do |bay| %>
          <%= bay.depth %>
        <% end %>

        <% table.with_column(Bay.human_attribute_name(:bay_type_id), name: :bay_type_id) do |bay| %>
          <%= bay.bay_type %>
        <% end %>

        <% table.with_column(Bay.human_attribute_name(:access_control), name: :access_control) do |bay| %>
          <%= bay.access_control %>
        <% end %>


        <% table.with_column(Server.model_name.human(count: 2), name: :server_id) do |bay| %>
          <%= link_to servers_path(bay_ids: bay.id), target: "_blank" do %>
            <%= Bay.human_attribute_name(:materials_count, count: bay.materials.count) %>
          <% end %>
        <% end %>

        <% table.with_column(Manufacturer.model_name.human, name: :manufacturer_id) do |bay| %>
          <%= link_to bay.manufacturer.name, manufacturer_path(bay.manufacturer), target: "_blank" if bay.manufacturer %>
        <% end %>
      <% end %>
    ERB

    def initialize(bays)
      @bays = bays
      super
    end
  end
end
