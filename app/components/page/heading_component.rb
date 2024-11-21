# frozen_string_literal: true

module Page
  class HeadingComponent < ApplicationComponent
    renders_one :right_content

    erb_template <<~ERB
      <%= render "layouts/breadcrumb", breadcrumb_steps: @breadcrumb_steps %>
      <div class="col-12 bg-body pb-5 pt-4 px-4">
        <div class="back-button-container mb-3">
          <% if @back_button_url %>
            <%= render ButtonComponent.new(t("action.back"),
                                          url: @back_button_url,
                                          icon: "chevron-left",
                                          extra_classes: "p-0 back-button") %>
          <% end %>
        </div>

        <div class="d-flex justify-content-between align-items-center column-gap-4">
          <% if @title %>
            <h1><%= @title %></h1>
          <% end %>

          <% if right_content? %>
            <%= right_content %>
          <% end %>
        </div>

        <%= content %>
      </div>
    ERB

    def initialize(title:, breadcrumb_steps:, back_button_url: nil)
      @title = title
      @breadcrumb_steps = breadcrumb_steps
      @back_button_url = back_button_url

      super
    end
  end
end
