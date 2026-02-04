# frozen_string_literal: true

module PdfHelper
  def inline_stylesheet_tag(name)
    asset_path = Rails.application.assets_manifest.assets["#{name}.css"]
    return "" unless asset_path

    css_content = Rails.public_path.join("assets", asset_path).read
    tag.style(css_content.html_safe, type: "text/css")
  rescue StandardError => e
    Rails.logger.error("Failed to inline stylesheet #{name}: #{e.message}")
    ""
  end
end
