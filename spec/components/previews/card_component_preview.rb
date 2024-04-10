# frozen_string_literal: true

class CardComponentPreview < ViewComponent::Preview
  def default
    render_with_template
  end

  # @param header_text text
  # @param type select { choices: [default, primary, success, info, warning, danger] }
  def with_header(header_text: "Ubi est germanus spatii?", type: :primary)
    render_with_template locals: { header_text:, type: }
  end

  # @param footer_text text
  def with_footer(footer_text: "Try sliceing stir-fry flavored with crême fraîche, mixed with lime.")
    render_with_template locals: { footer_text: }
  end

  # @param header_text text
  # @param footer_text text
  # @param type select { choices: [default, primary, success, info, warning, danger] }
  def with_header_footer(header_text: "Ubi est germanus spatii?",
                         footer_text: "Try sliceing stir-fry flavored with crême fraîche, mixed with lime.",
                         type: :primary)
    render_with_template locals: { header_text:, footer_text:, type: }
  end
end
