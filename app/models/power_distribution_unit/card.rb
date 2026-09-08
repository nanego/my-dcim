# frozen_string_literal: true

class PowerDistributionUnit
  class Card < CardAbstract
    belongs_to :power_distribution_unit

    def to_s
      "Carte #{power_distribution_unit} / #{card_type}"
    end
  end
end
