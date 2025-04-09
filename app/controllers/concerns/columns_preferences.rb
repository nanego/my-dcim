# frozen_string_literal: true

module ColumnsPreferences
  extend ActiveSupport::Concern

  included do
    before_action :set_model, only: :index
    before_action :columns_action, only: :index

    private

    def columns_action
      if reset_preferences?
        session[@model] = nil
      elsif save_preferences?
        session[@model] = params[:columns]
      end
    end

    def set_model
      @model = controller_path.classify.downcase.to_sym
    end

    def save_preferences?
      params[:save].present?
    end

    def reset_preferences?
      params[:reset].present?
    end
  end
end
