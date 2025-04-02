# frozen_string_literal: true

class ColumnsController < ApplicationController
  before_action :set_model, only: %i[save reset]

  def save
    session[@model] = columns_params[:columns]

    redirect_back_or_to root_path
  end

  def reset
    session[@model] = nil

    redirect_back_or_to root_path
  end

  private

  def set_model
    @model = params[:model]
  end

  def columns_params
    params.permit(:model, columns: [])
  end
end
