class DataImportController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:ansible]

  def index
  end

  def ansible
    respond_to do |format|
      format.html
      format.js
      format.json
    end
  end
end
