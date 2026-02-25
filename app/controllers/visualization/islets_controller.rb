# frozen_string_literal: true

module Visualization
  class IsletsController < BaseController
    before_action :set_islet, only: %i[print]

    def print
      respond_to do |format|
        format.html { render layout: "pdf" }
        format.pdf do
          render ferrum_pdf: {},
                 layout: "pdf",
                 filename: "islet_#{@islet}_#{[params[:view], params[:bg]].compact.join("-")}.pdf",
                 disposition: :inline
        end
      end
    end

    private

    def set_islet
      authorize! @islet = Islet.includes(
        :room,
        bays: :frames,
        servers: [
          :gestion, :cluster,
          { modele: %i[category composants],
            cards: [
              :composant,
              { ports: [{ connection: [{ cable: :connections }] }],
                card_type: [:port_type] },
            ] },
        ],
      )
        .find(params[:id])
    end
  end
end
