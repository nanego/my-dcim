class ExternalAppRequestsController < ApplicationController

  def show
    @external_app_request = ExternalAppRequest.find(params[:id])
    render json: { status: @external_app_request.status,
                   progress: @external_app_request.progress }
  end

  def destroy
    @external_app_request = ExternalAppRequest.find(params[:id])
    @external_app_request.destroy

    redirect_to external_app_records_path
  end

end
