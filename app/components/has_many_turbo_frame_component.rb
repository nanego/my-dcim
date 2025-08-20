# frozen_string_literal: true

class HasManyTurboFrameComponent < ApplicationComponent
  include Turbo::FramesHelper

  renders_one :actions

  erb_template <<~ERB
    <%= render CardComponent.new(type: @type, extra_classes: @extra_classes, **@html_options) do |c| %>
      <div class="d-flex justify-content-between align-items-center mb-3">
        <span class="d-inline-flex align-items-center">
          <h4 class="mb-0"><%= @title %></h4>
          <%= link_to @url, class: "ms-2 link-secondary" do %>
            <span class="bi bi-funnel-fill"
                  title="<%= t(".see_more_filters") %>"
                  aria-hidden="true"
                  data-controller="tooltip"
                  data-bs-placement="right"
            ></span>
          <% end %>
        </span>
      <% if actions? %>
        <%= actions %>
      <% elsif @new_path %>
        <%= link_to @new_path,
                    class: "link-success link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover small" do %>
          <span class="bi bi-plus-lg"></span>
          <span><%= @new_label %></span>
        <% end %>
      <% end %>
    </div>

      <%= turbo_frame_tag(@frame_id, loading: :lazy, src: @url) do %>
        <div class="w-100 d-flex justify-content-center align-items-center gap-3">
          <span role="status"><%= t(".loading") %></span>
          <span class="spinner-grow text-<%= @type %>" aria-hidden="true"></span>
        </div>
      <% end %>
    <% end %>
  ERB

  def initialize(title, url:, frame_id:, new_path: nil, new_label: nil, type: :primary, **html_options)
    @title = title
    @url = url
    @frame_id = frame_id
    @type = type
    @new_path = new_path
    @new_label = new_label
    @extra_classes = class_names("mt-4", "bg-body-tertiary")
    @html_options = html_options

    super()
  end
end
