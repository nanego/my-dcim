# frozen_string_literal: true

class LabelComponent < ApplicationComponent
  TYPES = %i[default primary secondary success info warning danger]

  erb_template <<~ERB
    <span class="<%= css_classes %>">
      <%= content %>
    </span>
  ERB

  def initialize(text = nil, type: :default)
    @text = text

    @type = type.to_sym
    raise ArgumentError, "'#{@type.inspect}' is not a valid type" unless TYPES.include?(@type)

    super()
  end

  def css_classes
    "badge text-#{@type}-emphasis bg-#{@type}-subtle border border-#{@type}-subtle"
  end

  def content
    super || @text
  end
end
