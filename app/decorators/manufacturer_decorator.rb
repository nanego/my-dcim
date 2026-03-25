# frozen_string_literal: true

class ManufacturerDecorator < ApplicationDecorator
  class << self
    def options_for_select
      Manufacturer.sorted.map { |r| [r.to_s, r.id] }
    end
  end
end
