# frozen_string_literal: true

require 'card_type'
require 'server'
require 'composant'
require 'category'

class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.includes(:owner, :trackable)
      .order('created_at desc')
      .page(params[:page]).per(100)
  end
end
