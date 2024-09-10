# frozen_string_literal: true

module Page
  class HeadingComponent < ApplicationComponent
    renders_one :extra_buttons

    erb_template <<~ERB
      <div class="col-12">
        <div class="d-flex justify-content-between pb-5">
          <% is_create_form = %w[new duplicate].include?(action_name) %>
          <%= link_to url_for(action: :index),
                      class: class_names("btn align-self-center d-inline-flex", "flex-grow-1": is_create_form),
                      title: t("action.back") do %>
            <span class="bi bi-chevron-left"></span>
            <span class="d-none d-md-inline-block ms-1"><%= t("action.back") %></span>
          <% end %>
          <h1 class="text-center px-4"><%= @title %></h1>
          <% if is_create_form %>
            <div class="flex-grow-1"></div>
          <% else %>
            <div class="align-self-center">
              <% if extra_buttons? %>
                <%= extra_buttons %>
              <% end %>

              <% if action_name == "show" %>
                <%= link_to url_for(action: :edit), class: "btn btn-info d-inline-flex", title: t("action.edit") do %>
                  <span class="bi bi-pencil"></span>
                  <span class="d-none d-xl-inline-block ms-1"><%= t("action.edit") %></span>
                <% end %>
              <% else %>
                <%= link_to url_for(action: :show), class: "btn btn-primary align-self-center d-inline-flex",
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

    def initialize(title:)
      @title = title

      super
    end
  end
end
