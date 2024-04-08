# frozen_string_literal: true

class CardComponentPreview < ViewComponent::Preview
  def default
    render_with_template
  end

  def with_header
    render_with_template
  end

  def with_footer
    render_with_template
  end

  def with_header_footer
    render_with_template
  end
end
