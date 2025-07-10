# frozen_string_literal: true

class HasManyTurboFrameComponent < ApplicationComponent
  include Turbo::FramesHelper

  renders_one :actions

  erb_template <<~ERB
    <%= render CardComponent.new(type: @type, extra_classes: @extra_classes, **@html_options) do |c| %>
      <% c.with_header do %>
        <div class="d-flex justify-content-between">
          <span><%= @title %></span>

          <% if actions? %>
            <%= actions %>
          <% else %>
          <div>
            <% if @new_path %>
              <%= render ButtonComponent.new(t("action.create"),
                                            url: @new_path,
                                            icon: "plus-lg",
                                            size: :sm,
                                            variant: :success,
                                            is_responsive: true,
                                            extra_classes: "me-3") %>
            <% end %>

            <%= link_to @url, class: class_names("link-light", "link-dark": @type == :warning) do %>
              <%= t(".see_more_filters") %>
              <% end %>
            <% end %>
          </div>
        </div>
      <% end %>

      <%= turbo_frame_tag(@frame_id, loading: :lazy, src: @url) do %>
        <div class="w-100 d-flex justify-content-center align-items-center gap-3">
          <span role="status"><%= t(".loading") %></span>
          <span class="spinner-grow text-<%= @type %>" aria-hidden="true"></span>
        </div>
      <% end %>
    <% end %>
  ERB

  def initialize(title, url:, frame_id:, new_path: nil, type: :primary, **html_options)
    @title = title
    @url = url
    @frame_id = frame_id
    @type = type
    @new_path = new_path
    @extra_classes = class_names("mt-4", "bg-body-tertiary")
    @html_options = html_options

    super()
  end
end
