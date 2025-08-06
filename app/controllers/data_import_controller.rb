# frozen_string_literal: true

class DataImportController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ansible]

  def index
    authorize!
  end

  def ansible
    authorize!

    respond_to do |format|
      format.html
      format.js
      format.json
    end
  end

  private

  def default_authorization_policy_class
    DataImportPolicy
  end
end
