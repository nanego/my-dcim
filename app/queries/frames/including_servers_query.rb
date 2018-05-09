module Frames
  class IncludingServersQuery
    DEFAULT_ORDER = 'asc'

    def self.call(relation = Frame.all, order = DEFAULT_ORDER)
      relation.includes(:islet => [:room],
                    :bay => [:frames],
                    :servers => [:frame,
                                 :gestion,
                                 :cluster,
                                 :modele => [:category, :composants],
                                 :cards => [:composant, :ports => [:connection => :cable], :card_type => :port_type]]).order(order)
    end

  end
end
