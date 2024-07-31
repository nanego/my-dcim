class ExternalAppRecord < ApplicationRecord

  belongs_to :server

  before_create :set_external_app_name

  private

  def set_external_app_name
    self.app_name = 'glpi' # Only one external app supported for now
  end

end
