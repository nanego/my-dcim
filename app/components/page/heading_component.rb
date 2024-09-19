# frozen_string_literal: true

module Page
  class HeadingComponent < ApplicationComponent
    BUTTONS = %i[show create edit none].freeze

    renders_one :extra_buttons

    erb_template <<~ERB
      <%= render "layouts/breadcrumb", breadcrumb_steps: @breadcrumb_steps %>
      <div class="col-12 bg-body pb-5 pt-4 px-4">
        <div class="d-flex justify-content-between align-items-center">
          <% if @buttons == :none %>
            <span class="flex-grow-1"></span>
          <% else %>
            <span class="<%= class_names("flex-grow-1": @buttons == :create) %>">
              <%= link_to polymorphic_url(@resource.class),
                          class: "btn d-inline-flex",
                          title: t("action.back") do %>
                <span class="bi bi-chevron-left"></span>
                <span class="d-none d-md-inline-block ms-1"><%= t("action.back") %></span>
              <% end %>
            </span>
          <% end %>
          <h1 class="text-center px-4"><%= @title %></h1>
          <% if %i[create none].include? @buttons %>
            <span class="flex-grow-1"></span>
          <% else %>
            <div class="align-self-center d-inline-flex">
              <% if extra_buttons? %>
                <%= extra_buttons %>
              <% end %>

              <% if @buttons == :show %>
                <%= link_to [:edit, @resource], class: "btn btn-info d-inline-flex", title: t("action.edit") do %>
                  <span class="bi bi-pencil"></span>
                  <span class="d-none d-xl-inline-block ms-1"><%= t("action.edit") %></span>
                <% end %>
              <% else %>
                <%= link_to @resource,
                            class: "btn btn-primary align-self-center d-inline-flex",
                            title: t("action.show") do %>
                  <span class="bi bi-eye"></span>
                  <span class="d-none d-md-inline-block ms-1"><%= t("action.show") %></span>
                <% end %>
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
    ERB

    def initialize(resource:, title:, breadcrumb_steps:, buttons: :show)
      @resource = resource
      @title = title
      @breadcrumb_steps = breadcrumb_steps

      @buttons = buttons.to_sym
      raise ArgumentError, "'#{@button.inspect}' is not a valid buttons type" unless BUTTONS.include?(@buttons)

      super
    end
  end
end
