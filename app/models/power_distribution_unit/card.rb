# frozen_string_literal: true

class PowerDistributionUnit
  class Card < CardAbstract
    belongs_to :record, polymorphic: true

    def to_s
      "#{model_name.human} #{record} / #{card_type}"
    end
  end
end
