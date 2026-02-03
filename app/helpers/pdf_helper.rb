# frozen_string_literal: true

module PdfHelper
  def inline_stylesheet_tag(name)
    asset_path = Rails.application.assets_manifest.assets["#{name}.css"]
    return "" unless asset_path

    css_content = File.read(Rails.root.join("public", "assets", asset_path))
    tag.style(css_content.html_safe, type: "text/css")
  rescue => e
    Rails.logger.error("Failed to inline stylesheet #{name}: #{e.message}")
    ""
  end
end
