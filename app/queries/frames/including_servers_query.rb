# frozen_string_literal: true

module Frames
  class IncludingServersQuery
    def self.call(relation = Frame.all, order = nil)
      ar_relation = relation.includes(islet: [:room],
                                      bay: [:frames],
                                      servers: [
                                        :frame, :gestion, :cluster,
                                        modele: [:category, :composants],
                                        cards: [
                                          :composant,
                                          ports: [:cable, connection: :cable],
                                          card_type: :port_type,
                                        ],
                                      ])
      ar_relation = ar_relation.order(order) if order
      ar_relation
    end
  end
end
