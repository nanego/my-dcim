class DataImportController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:ansible]

  def index
  end

  def ansible
  end
end
