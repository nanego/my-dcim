# frozen_string_literal: true

class FilterComponent < ApplicationComponent
  renders_one :form, ->(&block) { FilterComponent::Form.new(&block) }

  def initialize(filter)
    @filter = filter

    super()
  end

  class Form < ApplicationComponent
    delegate :call, to: :@block

    def initialize(&block)
      @block = block

      super()
    end
  end
end
