# frozen_string_literal: true

class DataImportController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ansible]

  def index
    authorize! with: DataImportPolicy
  end

  def ansible
    authorize! with: DataImportPolicy

    respond_to do |format|
      format.html
      format.js
      format.json
    end
  end
end
