# frozen_string_literal: true

class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.includes(:owner, :trackable).order('created_at desc')
    @pagy, @activities = pagy(@activities)
  end
end
