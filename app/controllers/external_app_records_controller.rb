class ExternalAppRecordsController < ApplicationController

  def index
    @external_app_records = ExternalAppRecord.includes(:server => :frame).order('servers.name')
    @filter = Filter.new(@external_app_records, params)
    @external_app_records = @filter.results
    @servers_count = Server.no_pdus.count
  end

  def sync
    Server.no_pdus.each do |server|
      ExternalAppRecord.create(server: server)
    end
    redirect_to external_app_records_url, notice: 'External app records were successfully synced'
  end

end
