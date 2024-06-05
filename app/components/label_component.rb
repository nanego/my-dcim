# frozen_string_literal: true

class LabelComponent < ApplicationComponent
  TYPES = %i[default primary success info warning danger]

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
    "badge text-bg-#{@type}"
  end

  def content
    super || @text
  end
end
