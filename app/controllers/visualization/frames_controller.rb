# frozen_string_literal: true

module Visualization
  class FramesController < BaseController
    before_action :set_frame, only: %i[show print]
    before_action :set_room, only: %i[show print]

    def show
      respond_to do |format|
        format.html
        format.js
        format.txt { send_data @frame.to_txt(params[:bg]) }
      end
    end

    def print
      render layout: "pdf"
    end

    private

    def set_frame
      authorize! @frame = Frame.includes(servers: [modele: %i[category composants],
                                                   cards: [:composant,
                                                           { ports: [connection: [cable: :connections]],
                                                             card_type: [:port_type] }]],
                                         bay: [islet: [:room]])
        .friendly
        .find(params[:id].to_s.downcase)
    end

    def set_room
      @room = @frame.room
    end
  end
end
