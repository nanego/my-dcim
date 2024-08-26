class ExternalAppRequestsController < ApplicationController

  def show
    @external_app_request = ExternalAppRequest.find(params[:id])
    render json: { status: @external_app_request.status,
                   progress: @external_app_request.progress }
  end

end
