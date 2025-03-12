# frozen_string_literal: true

class BadgeComponent < ApplicationComponent
  COLORS = %i[primary secondary success info warning danger light dark]
  TYPES = %i[default pill]

  erb_template <<~ERB
    <span class="<%= css_classes %>">
      <%= content %>
    </span>
  ERB

  def initialize(text = nil, type: :default, color: :primary)
    @text = text

    @type = type.to_sym
    raise ArgumentError, "'#{@type.inspect}' is not a valid type" unless TYPES.include?(@type)

    @color = color.to_sym
    raise ArgumentError, "'#{@color.inspect}' is not a valid color" unless COLORS.include?(@color)

    super()
  end

  def css_classes
    "badge text-#{@color}-emphasis bg-#{@color}-subtle border border-#{@color}-subtle \
    #{"rounded-pill" if @type == :pill}"
  end

  def content
    super || @text
  end
end
