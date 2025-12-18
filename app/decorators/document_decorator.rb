# frozen_string_literal: true

class DocumentDecorator < ApplicationDecorator
  def display_name
    object.document.metadata["filename"]
  end
end
