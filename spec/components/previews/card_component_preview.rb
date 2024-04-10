# frozen_string_literal: true

class CardComponentPreview < ViewComponent::Preview
  def default
    render_with_template
  end

  # @param header_text text
  # @param state select { choices: [default, primary, success, info, warning, danger] }
  def with_header(header_text: "Ubi est germanus spatii?", state: :primary)
    render_with_template locals: { header_text:, state: }
  end

  # @param footer_text text
  def with_footer(footer_text: "Try sliceing stir-fry flavored with crême fraîche, mixed with lime.")
    render_with_template locals: { footer_text: }
  end

  # @param header_text text
  # @param footer_text text
  # @param state select { choices: [default, primary, success, info, warning, danger] }
  def with_header_footer(header_text: "Ubi est germanus spatii?",
                         footer_text: "Try sliceing stir-fry flavored with crême fraîche, mixed with lime.",
                         state: :primary)
    render_with_template locals: { header_text:, footer_text:, state: }
  end
end
