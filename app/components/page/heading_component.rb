# frozen_string_literal: true

module Page
  class HeadingComponent < ApplicationComponent
    STYLES = %i[show create edit].freeze

    renders_one :extra_buttons

    erb_template <<~ERB
      <%= render "layouts/breadcrumb", breadcrumb_steps: @breadcrumb_steps %>
      <div class="col-12 bg-body pb-5 pt-4 px-4">
        <div class="d-flex justify-content-between align-items-center">
          <span class="<%= class_names("flex-grow-1": @style == :create) %>">
            <%= link_to polymorphic_url(@resource.class),
                        class: "btn d-inline-flex",
                        title: t("action.back") do %>
              <span class="bi bi-chevron-left"></span>
              <span class="d-none d-md-inline-block ms-1"><%= t("action.back") %></span>
            <% end %>
          </span>
          <h1 class="text-center px-4"><%= @title %></h1>
          <% if @style == :create %>
            <span class="flex-grow-1"></span>
          <% else %>
            <div class="align-self-center d-inline-flex">
              <% if extra_buttons? %>
                <%= extra_buttons %>
              <% end %>

              <% if @style == :show %>
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

    def initialize(resource:, title:, breadcrumb_steps:, style: :show)
      @resource = resource
      @title = title
      @breadcrumb_steps = breadcrumb_steps

      @style = style.to_sym
      raise ArgumentError, "'#{@style.inspect}' is not a valid type" unless STYLES.include?(@style)

      super
    end
  end
end
