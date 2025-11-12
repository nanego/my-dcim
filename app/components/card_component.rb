# frozen_string_literal: true

class CardComponent < ApplicationComponent
  # TODO: rename TYPES into COLORS
  TYPES = %i[default primary secondary success info warning danger].freeze

  renders_one :header
  renders_one :body, "BodyComponent"
  renders_one :footer

  erb_template <<~ERB
    <%= tag.div(**@html_attributes) do %>
      <% if header? %>
        <div class="<%= class_names("card-header fw-bold", "text-bg-\#{@type}": @type) %>">
          <%= header %>
        </div>
      <% end %>

      <% if body? %>
        <%= body %>
      <% else %>
        <%= render BodyComponent.new do %>
          <%= content %>
        <% end %>
      <% end %>

      <% if footer? %>
        <div class="<%= class_names("card-footer align-items-center d-flex",
                                    "bg-\#{@type}-subtle": @type, "border-\#{@type}": @type) %>">
          <%= footer %>
        </div>
      <% end %>
    <% end %>
  ERB

  def initialize(type: :default, extra_classes: "", **html_attributes)
    raise ArgumentError, "#{type} is not a valid type" unless TYPES.include?(type)

    @type = type unless type == :default
    @html_attributes = html_attributes
    @html_attributes[:class] = class_names("card", extra_classes, "border-#{@type}": @type)

    super
  end

  class BodyComponent < ApplicationComponent
    def initialize(extra_classes: "", **html_attributes)
      @html_attributes = html_attributes
      @html_attributes[:class] = class_names("card-body", extra_classes)

      super()
    end

    def call
      tag.div(content, **@html_attributes)
    end
  end
end
