# frozen_string_literal: true

module Page
  class HeadingComponent < ApplicationComponent
    renders_one :left_content
    renders_one :right_content

    erb_template <<~ERB
      <%= render "layouts/breadcrumb", breadcrumb_steps: @breadcrumb_steps %>
      <div class="col-12 bg-body pb-5 pt-4 px-4">
        <%= content %>

        <div class="d-flex justify-content-between align-items-center column-gap-4">
          <% if left_content? %>
            <%= left_content %>
          <% end %>

          <% if @title %>
            <h1 class="text-center"><%= @title %></h1>
          <% end %>

          <% if right_content? %>
            <%= right_content %>
          <% end %>
        </div>
      </div>
    ERB

    def initialize(title:, breadcrumb_steps:)
      @title = title
      @breadcrumb_steps = breadcrumb_steps

      super
    end
  end
end
