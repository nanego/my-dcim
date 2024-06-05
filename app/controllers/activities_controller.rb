# frozen_string_literal: true

class ActivitiesController < ApplicationController
  def index
    @pagy, @activities = pagy(PublicActivity::Activity.includes(:owner, :trackable).order('created_at desc'))
  end
end
