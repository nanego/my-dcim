# frozen_string_literal: true

class CardComponent < ApplicationComponent
  TYPES = %i[default primary secondary success info warning danger].freeze

  renders_one :header
  renders_one :footer

  erb_template <<~ERB
    <div class="<%= class_names("card mb-3 \#{@extra_classes}", "border-\#{@type}": @type) %>">
      <% if header? %>
        <div class="<%= class_names("card-header", "text-bg-\#{@type}": @type) %>">
          <%= header %>
        </div>
      <% end %>

      <div class="card-body">
        <%= content %>
      </div>

      <% if footer? %>
        <div class="<%= class_names("card-footer align-items-center d-flex",
                                    "bg-\#{@type}-subtle": @type, "border-\#{@type}": @type) %>">
          <%= footer %>
        </div>
      <% end %>
    </div>
  ERB

  def initialize(type: :default, extra_classes: "")
    raise ArgumentError, "#{type} is not a valid type" unless TYPES.include?(type)

    @type = type unless type == :default
    @extra_classes = extra_classes

    super
  end
end
