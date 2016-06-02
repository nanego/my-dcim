class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.includes(:owner, :trackable).order('created_at desc').page(params[:page]).per(100)
  end
end
