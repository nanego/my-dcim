# frozen_string_literal: true

module ColumnsPreferences
  extend ActiveSupport::Concern

  included do
    before_action :set_model, only: %i[save_columns reset_columns]

    def save_columns
      if save_preferences?
        session[@model] = columns_params[:columns]
        redirect_back_or_to root_path
      else
        redirect_back_with_params(columns: columns_params[:columns])
      end
    end

    def reset_columns
      session[@model] = nil

      redirect_back_or_to root_path
    end

    private

    def set_model
      @model = controller_path.classify.constantize
    end

    def columns_params
      params.permit(:save, columns: [])
    end

    def save_preferences?
      columns_params[:save] == "1"
    end

    def redirect_back_with_params(params = {})
      referer = request.referer || root_path
      redirect_to("#{referer}?#{params.to_query}")
    end
  end
end
