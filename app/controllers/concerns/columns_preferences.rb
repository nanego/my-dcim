# frozen_string_literal: true

module ColumnsPreferences
  extend ActiveSupport::Concern

  Columns = Data.define(:model, :default, :available, :preferred) do
    def available_columns_options
      available.index_with { |col| model.human_attribute_name(col) }
    end
  end

  class_methods do
    def columns_preferences_with(model:, default:, available:, key: controller_name, only: :index)
      before_action(only:) do
        if params[:reset]
          session[key] = nil
          redirect_to URI.parse(request.referer || root_path).path
        elsif params[:save]
          session[key] = params[:columns]
        end

        @columns_preferences = Columns.new(
          model:,
          default:,
          available:,
          preferred: params[:columns] || session[key] || default
        )
      end
    end
  end
end
