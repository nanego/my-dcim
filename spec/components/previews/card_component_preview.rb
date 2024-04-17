# frozen_string_literal: true

class CardComponentPreview < ViewComponent::Preview
  # @param type select { choices: [default, primary, success, info, warning, danger] }
  def default(type: :default)
    render CardComponent.new(type:) do |card|
      tag.p "Season fifteen oz of watermelon in one container of gold tequila."
    end
  end

  # @!group Types
  def type_default
    render CardComponent.new(type: :default) do |card|
      tag.p "Season fifteen oz of watermelon in one container of gold tequila."
    end
  end

  def type_primary
    render CardComponent.new(type: :primary) do |card|
      tag.p "Season fifteen oz of watermelon in one container of gold tequila."
    end
  end

  def type_success
    render CardComponent.new(type: :success) do |card|
      tag.p "Season fifteen oz of watermelon in one container of gold tequila."
    end
  end

  def type_info
    render CardComponent.new(type: :info) do |card|
      tag.p "Season fifteen oz of watermelon in one container of gold tequila."
    end
  end

  def type_warning
    render CardComponent.new(type: :warning) do |card|
      tag.p "Season fifteen oz of watermelon in one container of gold tequila."
    end
  end

  def type_danger
    render CardComponent.new(type: :danger) do |card|
      tag.p "Season fifteen oz of watermelon in one container of gold tequila."
    end
  end
  # @!endgroup

  # @param header_text text
  # @param type select { choices: [default, primary, success, info, warning, danger] }
  def with_header(header_text: "Ubi est germanus spatii?", type: :default)
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
                         type: :default)
    render_with_template locals: { header_text:, footer_text:, type: }
  end
end
