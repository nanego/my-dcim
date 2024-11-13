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
            <%= link_to @url, class: "link-light" do %>
              <%= t(".see_more_filters") %>
              <% end %>
          <% end %>
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

  def initialize(title, url:, frame_id:, type: :primary, **html_options)
    @title = title
    @url = url
    @frame_id = frame_id
    @type = type
    @extra_classes = class_names("mt-4", "bg-body-tertiary")
    @html_options = html_options

    super()
  end
end
