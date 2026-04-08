# frozen_string_literal: true

class EnclosureDecorator < ApplicationDecorator
  def display_name
    composants = object.composants.pluck(:name)

    composants_sentence = if composants.empty?
                            "0 #{Composant.model_name.human(count: 0).downcase}"
                          else
                            composants.map { |c| c.presence || "n/c" }.to_sentence
                          end

    "#{object.class.model_name.human} #{position} (#{composants_sentence})"
  end
end
